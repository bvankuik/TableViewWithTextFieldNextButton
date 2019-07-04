//
//  ExampleTableViewController.swift
//  TableViewWithTextFieldNextButton
//
//  Created by Bart van Kuik on 31/01/2017.
//  Copyright © 2017 DutchVirtual. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    private var counter = 0
    private let names = [
        "Allen","Upton","Hu","Yuli","Tiger","Flynn","Lev","Kyle","Sylvester","Mohammad",
        "Harlan","Julian","Sebastian","Porter","Preston","Palmer","Jakeem","Micah","Stephen","Tucker"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleTableViewCell", for: indexPath) as! ExampleTableViewCell
        cell.label.text = self.names[indexPath.row]
        cell.nextHandlerBlock = { [weak self] in
            self?.focusNextTextField(originCell: cell, in: tableView, from: indexPath)
        }
        cell.previousHandlerBlock = { [weak self] in
            self?.focusPreviousTextField(originCell: cell, in: tableView, from: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    // MARK: - Private functions

    private func focusPreviousTextField(originCell cell: UITableViewCell, in tableView: UITableView, from indexPath: IndexPath) {
        guard let currentIndexPath = self.tableView.indexPath(for: cell) else {
            // This can happen when the user scrolled after editing, but before tapping Next button
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            return
        }
        
        guard let previousIndexPath = tableView.previousIndexPath(for: currentIndexPath) else {
            return
        }
        
        self.animateFocus(on: previousIndexPath)
    }

    private func focusNextTextField(originCell cell: UITableViewCell, in tableView: UITableView, from indexPath: IndexPath) {
        guard let currentIndexPath = self.tableView.indexPath(for: cell) else {
            // This can happen when the user scrolled after editing, but before tapping Next button
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            return
        }
        
        guard let nextIndexPath = tableView.nextIndexPath(for: currentIndexPath) else {
            return
        }
        
        self.animateFocus(on: nextIndexPath)
    }
    
    private func animateFocus(on indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }, completion: { (finished) in
            if finished {
                let cell = self.tableView.cellForRow(at: indexPath) as! ExampleTableViewCell
                cell.textField.becomeFirstResponder()
            }
        })
    }
}

extension UITableView {
    func nextIndexPath(for currentIndexPath: IndexPath) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< self.numberOfSections {
            nextSection = section
            for row in startRow ..< self.numberOfRows(inSection: section) {
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
    
    func previousIndexPath(for currentIndexPath: IndexPath) -> IndexPath? {
        let startRow = currentIndexPath.row
        let startSection = currentIndexPath.section
        
        var previousRow = startRow
        var previousSection = startSection
        
        if startRow == 0 && startSection == 0 {
            return nil
        } else if startRow == 0 {
            previousSection -= 1
            previousRow = self.numberOfRows(inSection: previousSection) - 1
        } else {
            previousRow -= 1
        }
        
        return IndexPath(row: previousRow, section: previousSection)
    }
}
