//
//  ViewController.swift
//  SpendSwift
//
//  Created by gary on 18/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

class ItemsViewController: NSViewController {

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var itemCategoryPicker: NSPopUpButton!
    @IBOutlet weak var itemName: NSTextField!
    @IBOutlet weak var itemCost: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var totalCostLabel: NSTextField!

    enum CellType: String {
        case category = "CategoryCell"
        case name = "NameCell"
        case cost = "CostCell"
    }

    let defaultCategory = "Food"
    var model: SpendSwiftModel!
    var currentDate = Date()
    var categories: [Category]!
    var items: [Item]!
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()


    // MARK: - Actions

    @IBAction func addItem(_ sender: NSButton) {
        let category = categories[itemCategoryPicker.indexOfSelectedItem]
        model.newItem(category: category, name: itemName.stringValue, cost: itemCost.intValue, date: currentDate)
        refresh()
        itemName.selectText(nil)
    }


    @IBAction func changeDate(_ sender: NSDatePicker) {
        currentDate = sender.dateValue
        refresh()
    }


    @objc func deleteItem() {
        if items.count == 0 {
            return
        }
        let item = items[tableView.clickedRow]
        model.delete(item: item)
        refresh()
    }


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = NSApp.delegate as! AppDelegate
        model = appDelegate.model
        items = model.items(for: currentDate)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.menu = createMenu()
        itemName.delegate = self
        itemCost.delegate = self
        datePicker.dateValue = currentDate
    }


    override func viewWillAppear() {
        refreshCategories()
        refresh()
    }


    // MARK: - Private

    private func refresh() {
        items = model.items(for: currentDate)
        tableView.reloadData()
        setTotalCost()
        refreshAddButton()
    }


    private func refreshCategories() {
        categories = model.categories()
        setupCategoryPicker(categories: categories)
    }


    private func setupCategoryPicker(categories: [Category]) {
        itemCategoryPicker.removeAllItems()
        itemCategoryPicker.addItems(withTitles: categories.map { $0.name! })
        if itemCategoryPicker.indexOfItem(withTitle: defaultCategory) != -1    {
            itemCategoryPicker.selectItem(withTitle: "Food")
        } else {
            itemCategoryPicker.selectItem(at: 0)
        }
    }


    fileprivate func refreshAddButton() {
        addButton.isEnabled = itemName.stringValue.characters.count > 0 && itemCost.integerValue > 0
    }


    private func setTotalCost() {
        let totalCost = Double(items.reduce(0) { $0 + $1.cost })/100.0
        totalCostLabel.stringValue = numberFormatter.string(from: NSNumber(value: totalCost)) ?? "£0.00"
    }


    private func createMenu() -> NSMenu {
        let menu = NSMenu(title: "Delete")
        let item = NSMenuItem(title: "Delete", action: #selector(deleteItem), keyEquivalent: "")
        menu.addItem(item)
        return menu
    }
}


// MARK: - NSTableViewDataSource

extension ItemsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}


// MARK: - NSTableViewDelegate

extension ItemsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let identifier = tableColumn?.identifier,
            let cellType = CellType(rawValue: identifier.rawValue),
            let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView
        else {
            return nil
        }
        let item = items[row]
        switch cellType {
        case .category:
            cell.textField?.stringValue = item.itemCategory?.name ?? ""
        case .name:
            cell.textField?.stringValue = item.name ?? ""
        case .cost:
            let value = Double(item.cost)/100.0
            cell.textField?.stringValue = numberFormatter.string(from: NSNumber(value: value)) ?? "£0.00"
        }
        return cell
    }
}


// MARK: - NSTextFieldDelegate

extension ItemsViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        refreshAddButton()
    }
}
