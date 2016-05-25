//
//  RatingStarButton.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/24.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class RatingStarButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        /* ここに初期化したい要素を記述する */
        self.tintColor = UIColor.yellowColor()
    }

    

}
