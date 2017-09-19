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
    private var summaryData: SummaryData!

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
        summaryData = SummaryData(model: model)
        datePicker.dateValue = Date()
    }


    override func viewWillAppear() {
        refresh()
    }


    // MARK: - Private

    private func refresh() {
        let (firstDay, lastDay) = endpoints(date: datePicker.dateValue)
        costDescriptions.stringValue = summaryData.summary(from: firstDay, to: lastDay)
    }


    private func endpoints(date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: date)!
        return (interval.start, interval.end)
    }
}
