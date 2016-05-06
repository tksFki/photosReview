//
//  PopUpPickerView.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/05.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

@objc
protocol PopUpPickerViewDelegate: UIPickerViewDelegate {
    optional func pickerViewComplete(pickerView: UIPickerView, didSelect numbers: [Int])
    optional func pickerViewCancel(pickerView: UIPickerView)
}

class PopUpPickerView: UIView {

    var pickerView: UIPickerView!
    var pickerToolbar: UIToolbar!
    var toolbarItems: [UIBarButtonItem]!
    
    var delegate: PopUpPickerViewDelegate? {
        didSet {
            pickerView.delegate = delegate
        }
    }
    private var selectedRows: [Int]?
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFunc()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initFunc()
    }
    private func initFunc() {
        let screenSize = UIScreen.mainScreen().bounds.size
        self.backgroundColor = UIColor.lightGrayColor()
        
        pickerToolbar = UIToolbar(frame: CGRectMake(0, screenSize.height/6, screenSize.width, 40.0))
        pickerView = UIPickerView()
        toolbarItems = []
        
        pickerToolbar.translucent = true
        pickerToolbar.barStyle = .BlackTranslucent
        pickerToolbar.tintColor = UIColor.whiteColor()
        pickerToolbar.backgroundColor = UIColor.blackColor()
        pickerView.showsSelectionIndicator = true
        
        self.bounds = CGRectMake(0, 0, screenSize.width, 260)
        self.frame = CGRectMake(0, screenSize.height, screenSize.width, 260)
        pickerToolbar.bounds = CGRectMake(0, 0, screenSize.width, 44)
        pickerToolbar.frame = CGRectMake(0, 0, screenSize.width, 44)
        pickerView.bounds = CGRectMake(0, 0, screenSize.width, 216)
        pickerView.frame = CGRectMake(0, 44, screenSize.width, 216)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(PopUpPickerView.cancelPicker))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(PopUpPickerView.endPicker))
        toolbarItems! += [space, cancelItem, flexSpaceItem, doneButtonItem, space]
        
        pickerToolbar.setItems(toolbarItems, animated: false)
        self.addSubview(pickerToolbar)
        self.addSubview(pickerView)
    }

    func cancelPicker() {
        delegate?.pickerViewCancel!(pickerView)
    }
    func endPicker() {
        delegate?.pickerViewComplete!(pickerView, didSelect: getSelectedRows())
    }

    private func getSelectedRows() -> [Int] {
        var selectedRows = [Int]()
        for i in 0..<pickerView.numberOfComponents {
            selectedRows.append(pickerView.selectedRowInComponent(i))
        }
        return selectedRows
    }
    
    func setDefaultSelectRow(row:Int, inComponent componentsNumber:Int) {
        pickerView.selectRow(row, inComponent: componentsNumber, animated: false)
    }
}
