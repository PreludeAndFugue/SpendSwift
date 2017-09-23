//
//  SummaryItem.swift
//  SpendSwift
//
//  Created by gary on 23/09/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Foundation

final class SummaryItem {

    private let summaryLength = 40
    private let percentageLength = 7
    private let name: String
    private var cost: Int32
    private var total: Int32


    init(name: String) {
        self.name = name
        self.cost = 0
        self.total = 0
    }


    init(items: [SummaryItem]) {
        self.name = "Total"
        self.cost = items.map({ $0.cost }).reduce(0, { $0 + $1 })
        self.total = self.cost
    }


    func summary(using numberFormatter: NumberFormatter) -> String {
        let costNumber = NSNumber(value: Double(cost)/100)
        let costString = numberFormatter.string(from: costNumber) ?? "£0.00"
        let spaceLength = summaryLength - name.count - costString.count
        return name + String(repeating: " ", count: spaceLength) + costString + String(repeating: " ", count: percentageLength - percentage.count) + percentage
    }


    func add(item: Item) {
        total += item.cost
        if item.itemCategory.name == name {
            cost += item.cost
        }
    }


    // MARK: - Private

    private var percentage: String {
        if total == 0 {
            return "0.0%"
        }
        return String(format: "%0.1f%%", 100*Double(cost)/Double(total))
    }
}
