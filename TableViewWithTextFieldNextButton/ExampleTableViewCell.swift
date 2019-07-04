//
//  ExampleTableViewCell.swift
//  TableViewWithTextFieldNextButton
//
//  Created by Bart van Kuik on 31/01/2017.
//  Copyright © 2017 DutchVirtual. All rights reserved.
//

import UIKit


protocol ExampleTableViewCellDelegate: class {
    func exampleTableViewCell(_ cell: ExampleTableViewCell, didReturnFromEditingAt indexPath: IndexPath)
}

class ExampleTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath?
    var previousHandlerBlock: () -> Void = {}
    var nextHandlerBlock: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.returnKeyType = .next
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(self.previousButtonAction))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.nextButtonAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, previousButton, nextButton]
        self.textField.inputAccessoryView = toolbar
    }
    
    @objc func nextButtonAction() {
        self.nextHandlerBlock()
    }
    
    @objc func previousButtonAction() {
        self.previousHandlerBlock()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextButtonAction()
        return true
    }
}
