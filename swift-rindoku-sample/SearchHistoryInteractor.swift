//
//  SearchHistoryInteractor.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/22.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation

class SearchHistoryInteractor {
    
    func add(keyword: String) {
        let history = SearchHistory(date: Date(), keyword: keyword)
        
        let data = try? JSONEncoder().encode(history)
        UserDefaults.standard.set(data, forKey:"search_history")
    }
    
    func fetchLatestRecord() -> SearchHistory? {
        guard let data = UserDefaults.standard.data(forKey: "search_history") else {
            return nil
        }
        
        return try? JSONDecoder().decode(SearchHistory.self, from: data)
    }
}
