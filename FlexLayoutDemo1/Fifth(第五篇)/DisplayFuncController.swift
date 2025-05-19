//
//  DisplayFuncController.swift
//  FlexLayoutDemo1
//
//  Created by dy on 2025/5/15.
//  Copyright © 2025 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout

/**
 
 display(_ value: Display)
 display(_ value: Display) 用于设置视图的显示属性，类似于 CSS 中的 display 属性。它可以控制视图是否参与布局。

 可用的 Display 值：
 .flex：视图参与 Flex 布局（默认值）。
 .none：视图不参与布局，相当于隐藏视图。
 
 Flex.Display.contents 是 FlexLayout（通常指 FlexLayout for Swift）中的一个枚举值，对应 CSS 的 display: contents。
 它的作用是：让当前视图本身不参与布局，但它的子视图会像提升到父视图一样参与布局。

 使用场景
 你希望某个容器视图本身不占空间、不渲染，但它的子视图依然参与父视图的布局。
 适合做分组、逻辑包裹，但不希望影响布局结构。
 */

class DisplayFuncController: UIViewController {
    let rootFlexContainer = UIView()
    
    let toggleView = UIView()
    
    let contentsView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(rootFlexContainer)

        rootFlexContainer.flex.rowGap(20).marginTop(88).alignItems(.start).justifyContent(.center).define { flex in
            // 添加一个子视图
            flex.addItem(toggleView).width(100).height(100).backgroundColor(.red).display(.none)
            flex.addItem().width(100).height(100).backgroundColor(.blue)
            
            flex.addItem(contentsView).row().justifyContent(.center).alignItems(.stretch).height(100).display(.contents).define { flex in
                flex.addItem().width(100).height(100).backgroundColor(.systemBlue)
                flex.addItem().width(100).height(100).backgroundColor(.systemGray)
            }
        }

        // 初始时隐藏 toggleView,把它丢在上面的addItem里面的链式中了
        //toggleView.flex.display(.none)
        
        /// 此时的可以理解为将systemBlue与systemGray的两个方块从contentsView的这个行的布局这种移除,根据父级的rootFlexContainer来进行布局,rootFlexContainer是列布局,所以变成上下了
        /// 点击按钮之后,systemBlue与systemGray的两个方块回到contentsView的布局,列 -> 行
        /// 把它丢在上面的addItem里面的链式中了
        //contentsView.flex.display(.contents)

        // 添加按钮用于切换显示状态
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("切换显示", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleDisplay), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: toggleButton)
    }

    @objc func toggleDisplay() {
        // 切换 display 属性
        toggleView.flex.display(toggleView.flex.displayIsNone ? .flex : .none)
        
        contentsView.flex.display(contentsView.flex.displayIsContents ? .flex : .contents)

        // 更新布局
        rootFlexContainer.flex.layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout()
    }
}
