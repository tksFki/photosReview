//
//  CategorySelectButton.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategorySelectButton: CategoryButton{
    
    var categoryId:NSNumber = 0
    var categoryName:String = "カテゴリなし"
    var categoryTemplate:String = ""
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.touchStartAnimation()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        self.touchEndAnimation()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.touchEndAnimation()
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
