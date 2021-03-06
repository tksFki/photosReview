//
//  CommonButton.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/10.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

        override init(frame: CGRect) {
            super.init(frame: frame)
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
    
            /* ここに初期化したい要素を記述する */
            layer.cornerRadius = 4  /* 角の半径 */
            layer.borderWidth = 2  /* 枠線の太さ */
            layer.borderColor = UIColor.yellowColor().CGColor  /* 枠線の色 */
            layer.backgroundColor = UIColor.orangeColor().CGColor
        }

    private func touchStartAnimation(){
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {() -> Void in
                                    self.transform = CGAffineTransformMakeScale(0.85, 0.85)
            },
                                   completion: nil
        )
    }
    private func touchEndAnimation(){
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {() -> Void in
                                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },
                                   completion: nil
        )
    }
}
