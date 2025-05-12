//
//  IntroViewController.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout

import RxCocoa
import NSObject_Rx

class IntroViewController: UIViewController {
    
    fileprivate var rootFlexContainer = UIView()
    
    private let labelText = ["Flexbox layouting is simple, powerfull and fast.\n\nFlexLayout syntax is concise and chainable.",
                             "FlexLayout adds a nice Swift interface to the highly optimized facebook/yoga flexbox implementation. \n\nConcise, intuitive & chainable syntax.",
                             "Fast Swift Views layouting without auto layout. No magic, pure code, full control and blazing fast. \n\nConcise syntax, intuitive, readable & chainable. [iOS/macOS/tvOS/CALayer]"]
    
    private let bottomLabelText = ["FlexLayout/yoga is incredibly fast, its even faster than manual layout.",
                                   "Flexbox is an incredible improvement over UIStackView. It is simpler to use, much more versatile and amazingly performant.",
                                   "PinLayout layouts views immediately after the line containing .pin has been fully executed, thanks to ARC (Automatic Reference Counting) this works perfectly on iOS/tvOS/macOS simulators and devices. But in Xcode Playgrounds, ARC doesn't work as expected, object references are kept much longer. This is a well documented issue and have a little impact on the PinLayout behaviour."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    private func configUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexContainer)
        
        let imageView = UIImageView(image: UIImage(named: "flexlayout-logo"))
        
        let imageView1 = UIImageView(image: UIImage(named: "pinlayout-logo-text"))
        
        let segmentedControl = UISegmentedControl(items: ["Intro", "FlexLayout", "PinLayout"])
        segmentedControl.selectedSegmentIndex = 0
        
        let label = UILabel()
        label.text = labelText[segmentedControl.selectedSegmentIndex]
        label.numberOfLines = 0
        
        let bottomLabel = UILabel()
        bottomLabel.text = bottomLabelText[segmentedControl.selectedSegmentIndex]
        bottomLabel.numberOfLines = 0
        
        rootFlexContainer.flex.padding(12).define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(imageView).width(100).aspectRatio(of: imageView)
                flex.addItem().paddingLeft(12).grow(1).shrink(1).define { flex in
                    flex.addItem(segmentedControl).marginBottom(12).grow(1)
                    flex.addItem(label)
                }
            }
            // 分隔线
            flex.addItem().height(1).marginTop(12).backgroundColor(.lightGray)
            flex.addItem(bottomLabel).marginTop(12)
        }
        
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] selectIndex in

        }).dispose()
        
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] index in
            
            label.text = self?.labelText[index]
            label.flex.markDirty()
            
            bottomLabel.text = self?.bottomLabelText[index]
            bottomLabel.flex.markDirty()
            
//            if index == 0 {
//                imageView.flex.isLayoutAndShow = true
//                imageView1.flex.isLayoutAndShow = true
//            } else if index == 1 {
//                imageView.flex.isLayoutAndShow = true
//                imageView1.flex.isLayoutAndShow = false
//            } else if index == 2 {
//                imageView.flex.isLayoutAndShow = false
//                imageView1.flex.isLayoutAndShow = true
//            } else {
//                
//            }
            
            self?.rootFlexContainer.flex.layout(mode: .adjustHeight)
        }).disposed(by: rx.disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            rootFlexContainer.flex.margin(view.safeAreaInsets)
        } else {
            rootFlexContainer.flex.margin(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
        }
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
}
