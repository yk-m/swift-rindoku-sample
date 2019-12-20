//
//  SearchHistoryViewController.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/12/13.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController {
    
    var presenter: ListPresenter!
    weak var delegate: ListViewController?
    
    private let cellId = "cell"
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var items: [SearchHistory] = [] {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView else { return }
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        newCell.textLabel?.text = items[indexPath.row].keyword
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchHistoryView(self, didSelectRowAt: items[indexPath.row])
    }
}

extension SearchHistoryViewController {
    
    func set(items: [SearchHistory]) {
        self.items = items
    }
}
