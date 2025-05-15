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
 */

class DisplayFuncController: UIViewController {
    let rootFlexContainer = UIView()
    let toggleView = UIView()
    
    var isHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(rootFlexContainer)

        rootFlexContainer.flex.rowGap(20).marginTop(88).alignItems(.start).justifyContent(.center).define { flex in
            // 添加一个子视图
            flex.addItem(toggleView).width(100).height(100).backgroundColor(.red)
            flex.addItem().width(100).height(100).backgroundColor(.blue)
        }

        // 初始时隐藏 toggleView
        toggleView.flex.display(.none)
        isHidden = true

        // 添加按钮用于切换显示状态
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("切换显示", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleDisplay), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: toggleButton)
    }

    @objc func toggleDisplay() {
        // 切换 display 属性
        toggleView.flex.display(isHidden ? .flex : .none)
        isHidden = !isHidden

        // 更新布局
        rootFlexContainer.flex.layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout()
    }
}
