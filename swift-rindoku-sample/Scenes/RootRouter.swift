//
//  RootRouter.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/29.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class RootRouter {
    
    private init() {}
    
    static func showFirstView(window: UIWindow) {
        let listViewController = ListRouter.assembleModules()
        let navigationController = UINavigationController(rootViewController: listViewController)
        
        window.rootViewController = navigationController
        window.tintColor = .main
        
        window.makeKeyAndVisible()
    }
}
