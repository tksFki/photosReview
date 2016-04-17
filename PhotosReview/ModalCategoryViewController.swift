//
//  ModalCategoryViewController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

protocol ModalCategoryViewControllerDelegate {
    func modalDidFinished(modalText:String)
}

class ModalCategoryViewController: UIViewController{
    
    var delegate: ModalCategoryViewControllerDelegate! = nil
    
    @IBAction func categorySubmit(sender: UIButton) {
        let category:String = "餃子"
        self.delegate.modalDidFinished(category)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
