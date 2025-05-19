//
//  TableViewController.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/13.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FlexLayoutDemo1"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // 官方Demo界面
                navigationController?.pushViewController(IntroViewController(), animated: true)
            case 1: // 淘宝搜索标签界面
                navigationController?.pushViewController(TaobaoSearchVC(), animated: true)
            case 2: // 百词斩登录界面
                navigationController?.pushViewController(BCZViewController(), animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0: // 小说简介
                navigationController?.pushViewController(NovelSummaryVC(), animated: true)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0: // 我的钱包
                navigationController?.pushViewController(MyWalletVC(), animated: true)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0: // 沸点动态
                navigationController?.pushViewController(TweetListVC(), animated: true)
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(ReBuildController(), animated: true)
            case 1:
                navigationController?.pushViewController(DisplayFuncController(), animated: true)
            case 2:
                navigationController?.pushViewController(BoxSizingController(), animated: true)
            case 3:
                navigationController?.pushViewController(SnapKitLayoutController(), animated: true)
            default:
                break
            }
        default:
            break
        }
        
    }

}
