//
//  CommonLabel.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/12.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CommonLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        /* ここに初期化したい要素を記述する */
        layer.borderWidth = 1.0  /* 枠線の太さ */
        layer.borderColor = UIColor.yellowColor().CGColor  /* 枠線の色 */
        layer.backgroundColor = UIColor.orangeColor().CGColor /* 背景の色 */
    }

}
