//
//  SearchHistory.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/22.
//  Copyright © 2018 hicka04. All rights reserved.
//

import RealmSwift

class SearchHistory: Object {
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var keyword: String = ""
}
