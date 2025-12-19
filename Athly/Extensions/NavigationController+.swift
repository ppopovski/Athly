//
//  NavigationController+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    //Enables swipe to go back if .navigationBarBackButtonHidden(true)
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
