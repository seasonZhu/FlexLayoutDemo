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
        //setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            // 定义一个列
            flex.addItem().direction(.column).define { column in
                // 在列中添加一个行
                column.addItem().direction(.row).define { row in
                    // 在行中添加子视图
                    row.addItem(UIView()).width(50).height(50).backgroundColor(.red)
                    row.addItem(UIView()).width(50).height(50).backgroundColor(.blue)
                }

                // 在列中添加另一个子视图
                column.addItem(UIView()).width(100).height(50).backgroundColor(.green)
            }
        }
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
                flex.addItem().column().define { flex in
                    flex.addItem(imageView).width(100).aspectRatio(of: imageView)
                    flex.addItem(imageView1).width(100).aspectRatio(of: imageView1)
                }
                
                flex.addItem().paddingLeft(12).grow(1).shrink(1).define { flex in
                    flex.addItem(segmentedControl).marginBottom(12)
                    flex.addItem(label)
                }
            }
            // 分隔线
            flex.addItem().height(1).marginTop(12).backgroundColor(.lightGray)
            flex.addItem(bottomLabel).marginTop(12)
            
            /// 不管是行里加列,还是列里加行,都是可以的,就是需要设置宽高,保证可以撑起来,可以多调试几次
            flex.addItem().direction(.row).marginTop(20).define { flex in
                // 在列中添加一个行
                flex.addItem().direction(.column).grow(1).define { flex in
                    // 在行中添加子视图
                    flex.addItem(UIView()).height(50).backgroundColor(.red)
                    flex.addItem(UIView()).height(50).backgroundColor(.blue)
                }

                // 在列中添加另一个子视图
                flex.addItem(UIView()).paddingLeft(12).grow(1).backgroundColor(.green)
            }
        }
        
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] selectIndex in

        }).dispose()
        
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] index in
            
            label.text = self?.labelText[index]
            label.flex.markDirty()
            
            bottomLabel.text = self?.bottomLabelText[index]
            bottomLabel.flex.markDirty()
            
            if index == 0 {
                imageView.flex.isLayoutAndShow = true
                imageView1.flex.isLayoutAndShow = true
            } else if index == 1 {
                imageView.flex.isLayoutAndShow = true
                imageView1.flex.isLayoutAndShow = false
            } else if index == 2 {
                imageView.flex.isLayoutAndShow = false
                imageView1.flex.isLayoutAndShow = true
            } else {
                
            }
            
            self?.rootFlexContainer.flex.layout(mode: .adjustHeight)
        }).disposed(by: rx.disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.flex.margin(view.safeAreaInsets)
        
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
}
