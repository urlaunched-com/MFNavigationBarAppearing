//
//  MFLabelView.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 11/2/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit

class MFLabelView: UIView {
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: frame.height, width: 10, height: frame.height))
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .center
        label.textColor = tintColor ?? .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.size = bounds.size
    }
}
