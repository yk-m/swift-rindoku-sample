//
//  ListPresenter.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/29.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation

class ListPresenter {
    
    private weak var view: ListViewController?
    private let router: ListRouter
    private let interactor: SearchHistoryInteractor
    
    init(router: ListRouter, view: ListViewController, interactor: SearchHistoryInteractor) {
        self.router = router
        self.view = view
        self.interactor = interactor
    }
    
    private var searchText = "" {
        didSet {
            refresh()
            interactor.add(keyword: searchText)
        }
    }
}

extension ListPresenter {
    
    func viewDidLoad() {
        if let record = interactor.fetchLatestRecord() {
            self.searchText = record.keyword
            view?.set(searchText: record.keyword)
        }
        
        if let records = interactor.fetchRecords() {
            view?.set(history: records)
        }
    }
    
    func set(searchText: String) {
        self.searchText = searchText
        
        if let records = interactor.fetchRecords() {
            view?.set(history: records)
        }
    }
    
    func refresh() {
        let client = GitHubClient()
        client.send(request: GitHubAPI.SearchRepositories(keyword: searchText)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.view?.set(items: response.items)
            case .failure(let error):
                self?.view?.present(error: error)
            }
        }
    }
}
