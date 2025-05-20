//
//  SnapKitLayoutController.swift
//  FlexLayoutDemo1
//
//  Created by dy on 2025/5/19.
//  Copyright © 2025 darkhandz. All rights reserved.
//

import UIKit

import SnapKit

import PinLayout
import FlexLayout

class SnapKitLayoutController: UIViewController {
    
    var aView: UIView!
    
    var bView: UIView!
    
    var cView: UIView!
    
    var yellowView = UIView()
    
    let rootFlexContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        aView = UIView()
        aView.backgroundColor = .red
        
        bView = UIView()
        bView.backgroundColor = .yellow
        
        cView = UIView()
        cView.backgroundColor = .blue
        
        view.addSubview(aView)
        view.addSubview(bView)
        view.addSubview(cView)

        aView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(88)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        bView.snp.makeConstraints { make in
            make.top.equalTo(aView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        cView.snp.makeConstraints { make in
            make.top.equalTo(bView.snp.bottom).offset(10).priority(.high)
            make.top.equalTo(aView.snp.bottom).offset(10).priority(.low)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(rootFlexContainer)
        //rootFlexContainer.backgroundColor = .lightGray
        
        rootFlexContainer.flex.column().rowGap(10).alignItems(.stretch).define { flex in
            flex.addItem().height(50).backgroundColor(.systemRed)
            flex.addItem(yellowView).height(50).backgroundColor(.systemYellow).display(.flex)
            flex.addItem().height(50).backgroundColor(.systemBlue)
        }
        
        // 添加按钮用于切换显示状态
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("切换显示", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleDisplay(_:)), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: toggleButton)
    }

    @objc func toggleDisplay(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        bView.isHidden = button.isSelected
        
        if bView.isHidden {
            cView.snp.remakeConstraints { make in
                make.top.equalTo(aView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        } else {
            cView.snp.remakeConstraints { make in
                make.top.equalTo(bView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
        yellowView.flex.display(yellowView.flex.displayIsFlex ? .none : .flex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.frame = CGRect(x: 0, y: cView.frame.maxY + 10, width: view.bounds.width, height: view.bounds.height - (cView.frame.maxY + 10))
        
        rootFlexContainer.flex.layout()
    }
}

import NSObject_Rx
import RxCocoa

class TagsView: UIView {
    let rootFlexContainer = UIView()
    
    let relay = PublishRelay<[String]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rootFlexContainer)
        relay.subscribe(onNext: { [weak self] in
            self?.setTags($0)
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        //flex.layout()
    }
    
    func setTags(_ tags: [String]) {
        rootFlexContainer.flex.marginTop(88).define { flex in
            flex.removeAllElement()
            for tag in tags {
                flex.addItem().padding(8).backgroundColor(.lightGray).define { flex in
                    flex.addItem(UILabel()).margin(4).define { flex in
                        (flex.view as? UILabel)?.text = tag
                    }
                }
            }
        }
        setNeedsLayout()
    }
    
    deinit {
        print("\(TagsView.self)被销毁了")
    }
}

/// 这里其实隐藏着一个最小的MVVM模型
/// 我感觉通过FlexLayout/RxCocoa/Resolver可以构建一个理想的MVVM结构
class MVVMController: UIViewController {
    let tagsView = TagsView()
    
    let tagsRelay = BehaviorRelay<[String]>(value: ["RxSwift", "RxCocoa"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tagsView)
        tagsView.frame = view.bounds
        
        tagsRelay.bind(to: tagsView.relay).disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("\(MVVMController.self)被销毁了")
    }
}
