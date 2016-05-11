//
//  CommonTextField.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/11.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CommonTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        /* ここに初期化したい要素を記述する。以下は一例 */
        layer.cornerRadius = 8  /* ボタンの角の半径 */
        layer.borderWidth = 2.0  /* ボタンの枠線の太さ */
        layer.borderColor = UIColor.orangeColor().CGColor  /* ボタンの枠線の色 */
        
    }
}
