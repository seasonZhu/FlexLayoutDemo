//
//  MyCustomController.swift
//  FlexLayoutDemo1
//
//  Created by dy on 2025/5/21.
//  Copyright © 2025 darkhandz. All rights reserved.
//

import UIKit

import PinLayout
import FlexLayout


class MyCustomController: UIViewController {
    fileprivate let contentView = UIScrollView()
    
    fileprivate let rootFlexContainer = UIView()
    
    var views: [UIView] = []
    
    private var wrapFlex: Flex?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // 设置根容器的背景颜色
        rootFlexContainer.backgroundColor = .white
        
        contentView.addSubview(rootFlexContainer)
        
        view.addSubview(contentView)

        // 使用 FlexLayout 定义布局
        rootFlexContainer.flex.direction(.column).justifyContent(.start).alignItems(.center).define { flex in
            flex.addItem().backgroundColor(.red).height(50).width(100).marginTop(88).view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewBox)))
            flex.addItem().backgroundColor(.blue).height(50).width(100).marginTop(10).view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeNewBox)))
            
            
            self.wrapFlex = flex.addItem().direction(.row).wrap(.wrapReverse).justifyContent(.start).alignContent(.center).padding(10).define { flex in
                for i in 1...20 {
                    let box = UIView()
                    box.backgroundColor = .systemBlue
                    box.layer.cornerRadius = 5
                    box.flex.width(CGFloat(i * 10)).height(20).margin(5) // 设置子视图的宽高和外边距
                    views.append(box)
                    flex.addItem(box)
                }
            }
            
            flex.addItem().direction(.row).define { rowFlex in
                rowFlex.addItem().backgroundColor(.red).height(50).width(50)
                rowFlex.addItem().marginHorizontal(10)
                rowFlex.addItem().backgroundColor(.green).height(50).width(50)
            }.marginBottom(20)
            
            flex.addItem().direction(.column).define { columnFlex in
                columnFlex.addItem().backgroundColor(.blue).height(50).width(50)
                columnFlex.addItem().marginVertical(10)
                columnFlex.addItem().backgroundColor(.yellow).height(50).width(50)
            }
            
            flex.addItem().direction(.column).padding(20).define { columnFlex in
                let usernameField = UITextField()
                usernameField.placeholder = "用户名"
                usernameField.borderStyle = .roundedRect

                let passwordField = UITextField()
                passwordField.placeholder = "密码"
                passwordField.borderStyle = .roundedRect
                passwordField.isSecureTextEntry = true

                let loginButton = UIButton()
                loginButton.setTitle("登录", for: .normal)
                loginButton.backgroundColor = .systemBlue
                loginButton.layer.cornerRadius = 5

                /// columnFlex容器的大小初始化都是最小的,它应该会根据容器里面最大那个进行伸缩,所以可以定义容器的大小来决定子组件的宽高
                /// 亦或者定义一个子组件的宽高,其他子组件会去适应这个宽高
                //columnFlex.width(375)
                columnFlex.addItem(usernameField).height(50).paddingHorizontal(10).marginBottom(10)
                columnFlex.addItem(passwordField).height(50).paddingHorizontal(10).marginBottom(20)
                columnFlex.addItem(loginButton).width(375).height(50).paddingHorizontal(10)
            }
        }
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
    
    @objc func addNewBox() {
        let newBox = UIView()
        newBox.backgroundColor = .systemRed
        newBox.layer.cornerRadius = 5
        newBox.flex.size(80).margin(5)
        views.append(newBox)

        /// 这里其实引申Flutter性能优化的问题,刷新UI,根据需要的最小模块进行刷新
        wrapFlex?.addItem(newBox)
        //wrapFlex?.layout(mode: .adjustHeight) // 重新布局
        //rootFlexContainer.flex.layout(mode: .adjustHeight)
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    @objc func removeNewBox() {


        // 删除最后一个视图
        if let lastView = views.popLast() {
            lastView.removeFromSuperview()
//            rootFlexContainer.flex.layout()
        }
        contentView.flex.layout(mode: .adjustHeight)
    }
}
