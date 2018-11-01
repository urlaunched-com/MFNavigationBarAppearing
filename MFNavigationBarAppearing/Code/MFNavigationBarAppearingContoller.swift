//
//  MFNavigationBarAppearingContoller.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit


open class MFNavigationBarAppearingContoller: UINavigationController {
    
    public var appearingNavigationBar: MFAppearingNavigationBar? {
        return navigationBar as? MFAppearingNavigationBar
    }
    
    convenience init() {
        self.init(navigationBarClass: MFAppearingNavigationBar.self, toolbarClass: nil)
    }
    
    convenience override init(rootViewController: UIViewController) {
        self.init()
        
        appearingNavigationBar?.appearer = rootViewController as? MFNavigationBarAppearer
        viewControllers = [rootViewController]
        
        let viewColor = rootViewController.view.backgroundColor
        navigationBar.barTintColor = navigationBar.barTintColor ?? viewColor
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        appearingNavigationBar?.appearer = viewController as? MFNavigationBarAppearer
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let popedViewController = super.popViewController(animated: animated)
        appearingNavigationBar?.appearer = popedViewController as? MFNavigationBarAppearer
        return popedViewController
    }
}
