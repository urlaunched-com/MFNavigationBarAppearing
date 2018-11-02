//
//  MFLabelView.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 11/2/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit

class MFLabelView: UIView {
    weak var navigationBar: UINavigationBar?
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: frame.height, width: 10, height: frame.height))
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .center
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
        
        var size = label.sizeThatFits(bounds.size)
        size.width = min(size.width, bounds.width)
        size.height = min(size.height, bounds.height)
        label.frame.size = size
        
        let superview = navigationBar ?? self
        let originY = label.frame.origin.y
        
        label.center = CGPoint(x: superview.bounds.width / 2, y: label.center.y)
        label.center = superview.convert(label.center, to: self)
        label.frame.origin.x = max(0, label.frame.origin.x)
        label.frame.origin.y = originY
    }
}
