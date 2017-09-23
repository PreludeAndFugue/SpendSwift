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
    private let length = 30
    private let numberFormatter: NumberFormatter


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
        let categories = model.categories()
        let summaryItems = summarise(items: items, categories: categories)
        return summaryItems.map({ $0.summary(using: numberFormatter) }).joined(separator: "\n")
            + "\n\n" + SummaryItem(items: summaryItems).summary(using: numberFormatter)
    }


    // MARK: - Private

    private func summarise(items: [Item], categories: [Category]) -> [SummaryItem] {
        let summaryItems = categories.map({ SummaryItem(name: $0.name) })
        for item in items {
            for summaryItem in summaryItems {
                summaryItem.add(item: item)
            }
        }
        return summaryItems
    }
}
