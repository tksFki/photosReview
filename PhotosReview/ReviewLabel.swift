//
//  ReviewTitle.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/01.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class ReviewLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
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
