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
        
        (navigationController as? MFNavigationBarAppearingController)?.appearingNavigationBar?.navigationBarColor = .purple
//        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon_place"), style: .plain, target: nil, action: nil)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
//        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil),
//        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: nil, action: nil),
//        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: nil)]
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: nil)
//        (navigationController as? MFNavigationBarAppearingContoller)?.appearingNavigationBar?.titleAppearingAnimated = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationItem.titleView?.backgroundColor = .green
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
