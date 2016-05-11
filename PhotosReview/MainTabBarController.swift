//
//  MainTabBarController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/11.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アイコンの色を設定
        let colorKey = UIColor.brownColor()
        UITabBar.appearance().tintColor = colorKey
        
    }
}
