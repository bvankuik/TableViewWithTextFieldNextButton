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
    
    var delegate: ExampleTableViewCellDelegate?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.returnKeyType = .next
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let indexPath = self.indexPath {
            self.delegate?.exampleTableViewCell(self, didReturnFromEditingAt: indexPath)
        }
        return true
    }

}
