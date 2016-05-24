//
//  CategorySelectButton.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategorySelectButton: CategoryButton{
    
    var categoryId:NSNumber? = 0
    var categoryName:String? = ""
    var categoryTemplate:String? = ""
    
    var keepingButtonSelected:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        /* ここに初期化したい要素を記述する */
        layer.borderWidth = 1.0  /* 枠線の太さ */
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.yellowColor().CGColor  /* 枠線の色 */
        layer.backgroundColor = UIColor.orangeColor().CGColor /* 背景の色 */
    }
    
    // 画面に指を一本以上タッチしたときに実行されるメソッド
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesBegan(touches, withEvent: event)
//        print("touchesBegan")
//        self.touchStartAnimation()
//        self.selected = !self.keepingButtonSelected
//    }
    
//    // システムイベントがタッチイベントをキャンセルしたときに実行されるメソッド
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        super.touchesCancelled(touches, withEvent: event)
//        print("touchesCancelled")
//        self.touchEndAnimation()
//        self.selected = self.keepingButtonSelected;
//    }
    
    // 指を一本以上画面から離したときに実行されるメソッド
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesEnded(touches, withEvent: event)
//        print("touchesEnded")
//        self.touchEndAnimation()
//        for obj: AnyObject in touches{
//            let touch = obj as! UITouch
//            let touchPoint:CGPoint = touch.locationInView(self)
//            if (CGRectContainsPoint(self.bounds, touchPoint)) {
//                // UIControlEventTouchUpInside
//                self.selected = !self.keepingButtonSelected
//                self.keepingButtonSelected = self.selected
//            } else {
//                // UIControlEventTouchUpOutside
//                self.selected = self.keepingButtonSelected
//            }
//        }
//    }
    
    private func touchStartAnimation(){
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {() -> Void in
                                    self.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                    self.alpha = 0.7
            },
                                   completion: nil
        )
    }
    private func touchEndAnimation(){
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {() -> Void in
                                    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                    self.alpha = 1
            },
                                   completion: nil
        )
    }
    
    
}
