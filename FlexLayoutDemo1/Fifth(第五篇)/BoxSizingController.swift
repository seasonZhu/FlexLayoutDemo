//
//  BoxSizingController.swift
//  FlexLayoutDemo1
//
//  Created by dy on 2025/5/15.
//  Copyright © 2025 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout

/**
 boxSizing(_ value: BoxSizing) 用于设置视图的盒模型，类似于 CSS 中的 box-sizing 属性。它决定了宽度和高度是否包括内边距和边框。

 可用的 BoxSizing 值：
 .contentBox：宽度和高度包括内容、内边距和边框。
 .borderBox：宽度和高度只包括内容，不包括内边距和边框（默认值）。
 */

class BoxSizingController: UIViewController {
    let rootFlexContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rootFlexContainer)
        
        view.backgroundColor = .white

        rootFlexContainer.flex.marginTop(88).define { flex in
            // 使用 contentBox（默认）
            // 100 + left 10 + right 10 or 100 + top 10 + bottom 10 注意.contentBox只对padding有效果,对于margin是没有效果的
            flex.addItem().width(100).height(100).padding(10).margin(20).backgroundColor(.red).boxSizing(.contentBox)

            // 使用 borderBox 100 * 100
            flex.addItem().width(100).height(100).padding(10).backgroundColor(.blue).boxSizing(.borderBox)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.frame = view.bounds
        rootFlexContainer.flex.layout()
    }
}
