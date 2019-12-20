//
//  SearchHistoryInteractor.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/22.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistoryInteractor {
    
    let realm: Realm = {
        return try! Realm()
    }()
    
    func add(keyword: String) {
        if let oldRecord = realm.objects(SearchHistory.self).filter("keyword = %@", keyword).first {
            try! realm.write {
                oldRecord.date = Date()
            }
            return
        }
        
        let newRecord = SearchHistory()
        newRecord.keyword = keyword
        
        try! realm.write {
            realm.add(newRecord)
        }
    }
    
    func fetchLatestRecord() -> SearchHistory? {
        let realm = try! Realm()
        return realm.objects(SearchHistory.self).sorted(byKeyPath: "date", ascending: false).first
    }
    
    func fetchRecords() -> [SearchHistory]? {
        return Array(realm.objects(SearchHistory.self).sorted(byKeyPath: "date", ascending: false))
    }
}
