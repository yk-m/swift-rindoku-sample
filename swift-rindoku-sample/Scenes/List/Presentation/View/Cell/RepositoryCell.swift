//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = .main
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(repositoryName: String) {
        label.text = repositoryName
    }
    
}
