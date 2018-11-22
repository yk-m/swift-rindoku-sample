//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: String(describing: RepositoryCell.self), bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellId)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private let refreshControl = UIRefreshControl()
    
    var items: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchText = "" {
        didSet {
            DispatchQueue.main.async {
                self.refresh()
            }
        }
    }
    
    let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func refresh() {
        let client = GitHubClient()
        client.send(request: GitHubAPI.SearchRepositories(keyword: searchText)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.items
            case .failure(.connectionError(_)):
                self?.present({
                    let alert = UIAlertController(title: "通信に失敗しました", message: "ネットワーク接続を確認してください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alert
                }(), animated: true, completion: nil)
            case .failure(_):
                self?.present({
                    let alert = UIAlertController(title: "ただいま混み合っています", message: "時間をあけて再度お試しください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    return alert
                }(), animated: true, completion: nil)
            }
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
        guard let searchText = searchBar.text else {
            return
        }
        
        self.searchText = searchText
        searchController.dismiss(animated: true)
    }
}
