//
//  SummaryViewController.swift
//  SpendSwift
//
//  Created by gary on 18/09/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

class SummaryViewController: NSViewController {

    private var model: SpendSwiftModel!
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var costDescriptions: NSTextField!
    

    // MARK: - Actions

    @IBAction func changeDate(_ sender: NSDatePicker) {
        refresh()
    }


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = NSApp.delegate as! AppDelegate
        model = appDelegate.model
        datePicker.dateValue = Date()
    }


    override func viewWillAppear() {
        refresh()
    }


    // MARK: - Private

    private func refresh() {
        let (firstDay, lastDay) = endpoints(date: datePicker.dateValue)
        let items = model.items(from: firstDay, to: lastDay)
        let costs = costPerCategory(items: items)
        costDescriptions.stringValue = stringOf(costs: costs)
    }


    private func endpoints(date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: date)!
        return (interval.start, interval.end)
    }


    private func costPerCategory(items: [Item]) -> [Category: Int32] {
        var costs: [Category: Int32] = emptyCategoryCosts()
        for item in items {
            guard let category = item.itemCategory else { continue }
            if let cost = costs[category] {
                costs[category] = cost + item.cost
            } else {
                costs[category] = item.cost
            }
        }
        return costs
    }


    private func stringOf(costs: [Category: Int32]) -> String {
        var costStrings: [String] = []
        for (category, cost) in costs {
            let costString = numberFormatter.string(from: NSNumber(value: Double(cost)/100.0))!
            costStrings.append("\(category.name!): \(costString)")
        }
        return costStrings.joined(separator: "\n")
    }


    private func emptyCategoryCosts() -> [Category: Int32] {
        var costs: [Category: Int32] = [:]
        for category in model.categories() {
            costs[category] = 0
        }
        return costs
    }
}
