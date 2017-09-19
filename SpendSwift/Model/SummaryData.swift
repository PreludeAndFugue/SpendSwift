//
//  SummaryData.swift
//  SpendSwift
//
//  Created by gary on 19/09/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Foundation

struct SummaryData {

    private let model: SpendSwiftModel
    private let numberFormatter: NumberFormatter
    private let length = 30


    init(model: SpendSwiftModel) {
        self.model = model
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        self.numberFormatter = numberFormatter
    }


    func summary(from fromDate: Date, to toDate: Date) -> String {
        let items = model.items(from: fromDate, to: toDate)
        let categoryCosts = costPerCategory(items: items)
        var strings = categoryCosts.sorted(by: { $0.key.name < $1.key.name }).map({ costString(category: $0.key, cost: $0.value) })
        strings.append("\n")
        strings.append(totalCostString(costs: categoryCosts.values.map({ $0 })))
        return strings.joined(separator: "\n")
    }


    // MARK: - Private

    private func costPerCategory(items: [Item]) -> [Category: Int32] {
        var costs: [Category: Int32] = emptyCategoryCosts()
        for item in items {
            let category = item.itemCategory
            if let cost = costs[category] {
                costs[category] = cost + item.cost
            } else {
                costs[category] = item.cost
            }
        }
        return costs
    }


    private func emptyCategoryCosts() -> [Category: Int32] {
        var costs: [Category: Int32] = [:]
        for category in model.categories() {
            costs[category] = 0
        }
        return costs
    }


    private func costString(category: Category, cost: Int32) -> String {
        let name = category.name
        let costNumber = NSNumber(value: Double(cost)/100)
        let costNumberString = numberFormatter.string(from: costNumber) ?? "£0.00"
        return join(part1: name, part2: costNumberString)
    }


    private func totalCostString(costs: [Int32]) -> String {
        let totalCost = costs.reduce(0, { $0 + $1 })
        let totalCostNumber = NSNumber(value: Double(totalCost)/100)
        let totalString = numberFormatter.string(from: totalCostNumber) ?? "£0.00"
        return join(part1: "Total", part2: totalString)
    }


    private func join(part1: String, part2: String) -> String {
        return part1 + String(repeating: " ", count: length - part1.count - part2.count) + part2
    }
}
