//
//  UIRefreshControl+extension.swift
//  swift-rindoku-sample
//
//  Created by sci01725 on 2018/11/15.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    func beginRefreshingManually(in scrollView: UIScrollView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        scrollView.setContentOffset(offsetPoint, animated: true)
    }
}
