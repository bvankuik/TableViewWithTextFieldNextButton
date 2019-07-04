//
//  ExampleTableViewController.swift
//  TableViewWithTextFieldNextButton
//
//  Created by Bart van Kuik on 31/01/2017.
//  Copyright © 2017 DutchVirtual. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController, ExampleTableViewCellDelegate {
    private var counter = 0
    private let names = [
        "Allen","Upton","Hu","Yuli","Tiger","Flynn","Lev","Kyle","Sylvester","Mohammad",
        "Harlan","Julian","Sebastian","Porter","Preston","Palmer","Jakeem","Micah","Stephen","Tucker"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleTableViewCell", for: indexPath) as! ExampleTableViewCell
        cell.label.text = self.names[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.handlerBlock = { [weak self] in
            // As an alternative to a delegate, you can use a handler.
            self?.counter += 1
            print("nextButtonHandler: \(self?.counter ?? 0)")
        }
        return cell
    }
    
    // MARK: - ExampleTableViewCellDelegate
    
    func exampleTableViewCell(_ cell: ExampleTableViewCell, didReturnFromEditingAt indexPath: IndexPath) {
        NSLog("Did return from editing at \(indexPath)")
        
        guard let currentIndexPath = self.tableView.indexPath(for: cell) else {
            // This can happen when the user scrolled after editing, but before tapping Next button
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            return
        }
        
        guard let nextIndexPath = self.nextIndexPath(for: currentIndexPath, in: self.tableView) else {
            return
        }
        
        self.focusResultTextField(on: nextIndexPath)
    }
    
    // MARK: - Private functions
    
    private func focusResultTextField(on indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }, completion: { (finished) in
            if finished {
                let cell = self.tableView.cellForRow(at: indexPath) as! ExampleTableViewCell
                cell.textField.becomeFirstResponder()
            }
        })
    }
    
    private func nextIndexPath(for currentIndexPath: IndexPath, in tableView: UITableView) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< tableView.numberOfSections {
            nextSection = section
            for row in startRow ..< tableView.numberOfRows(inSection: section) {
                nextRow = row
                iteration += 1
                if iteration == 2 {
                    let nextIndexPath = IndexPath(row: nextRow, section: nextSection)
                    return nextIndexPath
                }
            }
            startRow = 0
        }
        
        return nil
    }
}
