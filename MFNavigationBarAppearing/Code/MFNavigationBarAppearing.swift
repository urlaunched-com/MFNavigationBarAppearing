//
//  MFNavigationBarAppearing.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit

open protocol MFNavigationBarAppearer: class {
    var appearingScrollView: UIScrollView? { get }
    var navigationBarStartAppearingOffset: CGFloat { get }
    var navigationBarEndAppearingOffset: CGFloat? { get }
    
    var appearingTitle: String? { get }
    var appearingTitleStartOffsetAfterAppearingNavBar: CGFloat? { get }
    var appearingTitleEndOffsetAfterAppearingNavBar: CGFloat? { get }
}

extension MFNavigationBarAppearer {
    var navigationBarEndAppearingOffset: CGFloat? {
        return nil
    }
    
    var appearingTitle: String? {
        return nil
    }
    
    var appearingTitleStartOffsetAfterAppearingNavBar: CGFloat? {
        return nil
    }
    
    var appearingTitleEndOffsetAfterAppearingNavBar: CGFloat? {
        return nil
    }
}
