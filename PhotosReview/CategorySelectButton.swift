//
//  CategorySelectButton.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategorySelectButton: CategoryButton{
    
    var categoryId:NSNumber? = 0
    var categoryName:String? = ""
    var categoryTemplate:String? = ""
    
    var keepingButtonSelected:Bool = false
    
    // 画面に指を一本以上タッチしたときに実行されるメソッド
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print("touchesBegan")
        self.touchStartAnimation()
        self.selected = !self.keepingButtonSelected
    }
    
//    // システムイベントがタッチイベントをキャンセルしたときに実行されるメソッド
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        super.touchesCancelled(touches, withEvent: event)
//        print("touchesCancelled")
//        self.touchEndAnimation()
//        self.selected = self.keepingButtonSelected;
//    }
    
    // 指を一本以上画面から離したときに実行されるメソッド
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("touchesEnded")
        self.touchEndAnimation()
        for obj: AnyObject in touches{
            let touch = obj as! UITouch
            let touchPoint:CGPoint = touch.locationInView(self)
            if (CGRectContainsPoint(self.bounds, touchPoint)) {
                // UIControlEventTouchUpInside
                self.keepingButtonSelected = !self.keepingButtonSelected
            } else {
                // UIControlEventTouchUpOutside
                self.selected = self.keepingButtonSelected
            }
        }
    }
    
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
