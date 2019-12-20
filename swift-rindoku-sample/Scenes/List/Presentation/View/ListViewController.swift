//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var presenter: ListPresenter!
    private let searchHistoryView: SearchHistoryViewController
    
    private let cellId = "cell"
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: String(describing: RepositoryCell.self), bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellId)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchHistoryView)
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var items: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    init(searchHistoryView: SearchHistoryViewController) {
        self.searchHistoryView = searchHistoryView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        newCell.set(repositoryName: items[indexPath.row].fullName)
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(repository: items[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        defer {
            searchController.dismiss(animated: true)
        }
        guard let searchText = searchBar.text,
            searchText != "" else {
            return
        }
        
        presenter.set(searchText: searchText)
    }
}

extension ListViewController {
    
    func set(searchText: String) {
        searchController.searchBar.text = searchText
    }
    
    func set(history: [SearchHistory]) {
        searchHistoryView.set(items: history)
    }
    
    func set(items: [Repository]) {
        self.items = items
    }
    
    func present(error: GitHubClientError) {
        let title: String
        let message: String
        
        switch error {
        case .connectionError(_):
            title = "通信に失敗しました"
            message = "ネットワーク接続を確認してください。"
        case .responseParseError(_):
            title = "ただいま混み合っています"
            message = "時間をあけて再度お試しください。"
        case .apiError(let error):
            title = "エラーが発生しました"
            message = error.message
        }
        
        self.present({
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alert
        }(), animated: true, completion: nil)
    }
}

extension ListViewController {
    
    func searchHistoryView(_ searchHistoryView: SearchHistoryViewController, didSelectRowAt history: SearchHistory) {
        
        presenter.set(searchText: history.keyword)
    }
}
