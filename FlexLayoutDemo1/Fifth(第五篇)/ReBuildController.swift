//
//  ReBuildController.swift
//  FlexLayoutDemo1
//
//  Created by dy on 2025/5/15.
//  Copyright © 2025 darkhandz. All rights reserved.
//



import UIKit
import FlexLayout

class ReBuildController: UIViewController {
    
    fileprivate let contentView = UIScrollView()
    
    fileprivate let rootFlexContainer = UIView()
    
    var data: [String] = ["Item 1", "Item 2", "Item 3"] // 数据源

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        rootFlexContainer.backgroundColor = .white
        
        contentView.addSubview(rootFlexContainer)
        
        view.addSubview(contentView)

        // 初始化布局
        setupLayout()

        // 添加按钮用于操作数据
        setupButtons()
    }

    func setupLayout() {
        rootFlexContainer.flex.define { flex in

            // 根据数据源动态创建视图
            for (index, item) in data.enumerated() {
                flex.addItem().direction(.row).marginBottom(10).define { row in
                    // 显示数据内容的标签
                    row.addItem(UILabel()).grow(1).define { flex in
                        let label = flex.view as! UILabel
                        label.text = item
                        label.textColor = .black
                    }

                    // 删除按钮
                    row.addItem(UIButton(type: .system)).width(50).height(30).define { flex in
                        let button = flex.view as! UIButton
                        button.setTitle("删除", for: .normal)
                        button.tag = index // 用 tag 记录索引
                        button.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
                    }
                }
            }
        }
    }

    func setupButtons() {
        // 添加按钮
        let addButton = UIButton(type: .system)
        addButton.setTitle("新增项", for: .normal)
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        addButton.frame = CGRect(x: 20, y: 400, width: 100, height: 40)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }

    @objc func addItem() {
        // 新增数据
        let newItem = "Item \(data.count + 1)"
        data.append(newItem)

        // 清空并重新设置布局
        rootFlexContainer.flex.view?.subviews.forEach { $0.removeFromSuperview() }
        setupLayout()

        // 更新布局
        contentView.flex.layout(mode: .adjustHeight)
    }

    @objc func deleteItem(_ sender: UIButton) {
        // 根据按钮的 tag 删除对应的数据项
        let index = sender.tag
        guard index < data.count else { return }
        data.remove(at: index)

        // 清空并重新设置布局
        rootFlexContainer.flex.view?.subviews.forEach { $0.removeFromSuperview() }
        setupLayout()

        // 更新布局
        contentView.flex.layout(mode: .adjustHeight)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 1) Layout the contentView & rootFlexContainer using PinLayout
        contentView.frame = view.bounds
        rootFlexContainer.pin.top().left().right().bottom()

        // 2) Let the flexbox container layout itself and adjust the height
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        // 3) Adjust the scrollview contentSize
        contentView.contentSize = rootFlexContainer.frame.size
    }
}

