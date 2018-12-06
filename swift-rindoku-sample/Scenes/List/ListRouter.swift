//
//  ListRouter.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/29.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListRouter {
    
    weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules() -> UIViewController {
        let view = ListViewController()
        let interactor = SearchHistoryInteractor()
        let router = ListRouter(viewController: view)
        let presenter = ListPresenter(router: router, view: view, interactor: interactor)
        
        view.presenter = presenter
        
        return view
    }
}

extension ListRouter {
    
    func translateToDetail(repository: Repository) {
        let detail = DetailViewController(repository: repository)
        viewController?.navigationController?.pushViewController(detail, animated: true)
    }
}
