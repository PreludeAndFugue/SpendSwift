//
//  File.swift
//  SpendSwift
//
//  Created by gary on 18/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa


struct DefaultData {

    let data = ["Business", "DIY", "Food", "Misc", "Music", "Sport", "Transport", "Utilities"]
    let model: SpendSwiftModel

    
    init(model: SpendSwiftModel) {
        self.model = model
    }


    func insert() {
        print("inserting default data")
        if isAlreadyInserted() {
            return
        }
        model.newCategories(with: data)
    }


    private func isAlreadyInserted() -> Bool {
        return model.categories().count > 0
    }
}
