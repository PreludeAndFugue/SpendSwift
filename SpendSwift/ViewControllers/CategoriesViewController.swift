//
//  CategoriesViewController.swift
//  SpendSwift
//
//  Created by gary on 18/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

class CategoriesViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var newCategoryName: NSTextField!
    @IBOutlet weak var addButton: NSButton!

    fileprivate let cellIdentifier = "CategoryCell"
    fileprivate var model: SpendSwiftModel!
    fileprivate var categories: [Category]!


    // MARK: - Actions

    @IBAction func addNewCategory(_ sender: NSButton) {
        let newName = newCategoryName.stringValue.trimmingCharacters(in: .whitespaces)
        model.newCategory(name: newName)
        refresh()
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = NSApp.delegate as! AppDelegate
        model = appDelegate.model
        refresh()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.menu = createMenu()
        newCategoryName.delegate = self
    }


    @objc func deleteCategory() {
        let category = categories[tableView.clickedRow]
        let itemCount = model.countItems(with: category)
        if itemCount > 0 {
            let alert = NSAlert()
            alert.alertStyle = .informational
            alert.messageText = "Cannot delete"
            alert.informativeText = "Category is attached to items, cannot delete"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        } else {
            model.delete(category: category)
            refresh()
        }
    }

    
    // MARK: - Private

    private func refresh() {
        categories = model.categories()
        tableView.reloadData()
    }


    private func createMenu() -> NSMenu {
        let menu = NSMenu(title: "Delete")
        let item = NSMenuItem(title: "Delete", action: #selector(deleteCategory), keyEquivalent: "")
        menu.addItem(item)
        return menu
    }
}


// MARK: - NSTableViewDataSource

extension CategoriesViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return categories.count
    }
}


// MARK: - NSTableViewDelegate

extension CategoriesViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = categories[row].name
            return cell
        }
        return nil
    }
}


// MARK: - NSTextFieldDelegate

extension CategoriesViewController: NSTextFieldDelegate {

    override func controlTextDidChange(_ obj: Notification) {
        if newCategoryName.stringValue.characters.count == 0 || categoryAlreadyExists() {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
    }


    private func categoryAlreadyExists() -> Bool {
        let newName = newCategoryName.stringValue.trimmingCharacters(in: .whitespaces).lowercased()
        for category in categories {
            let currentName = category.name.lowercased()
            if newName == currentName {
                return true
            }
        }
        return false
    }
}
