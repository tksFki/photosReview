//
//  CategoryButton.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

@IBDesignable
class CategoryButton: UIButton{
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        
//        /* ここに初期化したい要素を記述する。以下は一例 */
//        layer.cornerRadius = 10;  /* ボタンの角の半径 */
//        layer.borderWidth = 1;  /* ボタンの枠線の太さ */
//        layer.borderColor = UIColor.blueColor().CGColor;  /* ボタンの枠線の色 */
//    }
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
}

