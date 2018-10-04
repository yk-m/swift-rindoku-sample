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
    let data = ["a", "b", "c", "d"]
    let sections = ["1", "2", "3"]
    
    let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: String(describing: RepositoryCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        newCell.set(repositoryName: data[indexPath.row])
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
