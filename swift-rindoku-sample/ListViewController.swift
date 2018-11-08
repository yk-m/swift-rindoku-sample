//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var items: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: String(describing: RepositoryCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
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
