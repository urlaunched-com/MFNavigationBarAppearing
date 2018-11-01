//
//  MainViewController.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .purple
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
//        (navigationController as? MFNavigationBarAppearingContoller)?.appearingNavigationBar?.titleAppearingAnimated = true
    }
}


//MARK: - MFNavigationBarAppearer
extension MainViewController: MFNavigationBarAppearer {
    
    var appearingScrollView: UIScrollView? {
        return scrollView
    }
    
    var navigationBarStartAppearingOffset: CGFloat {
        return titleLabel.frame.origin.y - 50
    }
    
    var navigationBarEndAppearingOffset: CGFloat? {
        return titleLabel.frame.origin.y
    }
    
    var appearingTitle: String? {
        return titleLabel.text
    }
    
    var appearingTitleEndOffsetAfterAppearingNavBar: CGFloat? {
        return titleLabel.frame.maxY
    }
}
