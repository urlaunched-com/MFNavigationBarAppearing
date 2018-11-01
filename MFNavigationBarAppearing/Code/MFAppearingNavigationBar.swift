//
//  MFAppearingNavigationBar.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit


open class MFAppearingNavigationBar: UINavigationBar {

    public enum AppearingState {
        case appeared, disappeared, appearing
    }
    
    open private(set) var titleLabel: UILabel?
    open private(set) var appearingState: AppearingState = .disappeared
    
    open var titleAppearingInteractive = true
    open var titleAppearingAnimated = false {
        didSet {
            titleAppearingInteractive = !titleAppearingAnimated
        }
    }
    
    open var animationDuration: TimeInterval = 0.33
    open weak var appearer: MFNavigationBarAppearer?
    
    private var barBackgroundView: UIView?
    private var customTitleContainer: UIView?
    private var observation: NSKeyValueObservation?
    
    override var barTintColor: UIColor? {
        didSet {
            if topItem?.titleView != nil {
                setNeedsLayout()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        
        if topItem?.titleView != customTitleContainer || topItem?.titleView == nil {
            setupTitleContainer()
        }
        
        if let scrollView = appearer?.appearingScrollView {
            observation = scrollView.observe(\.contentOffset, changeHandler: { [weak self] (scrollView, change) in
                self?.setupForNew(yOffset: scrollView.contentOffset.y)
            })
        }
    }
}


//MARK: - Configuretions
private extension MFAppearingNavigationBar {
    
    func setupUI() {
        barBackgroundView = subviews.first
        barBackgroundView?.backgroundColor = barTintColor ?? .black
        
        if let barBackgroundView = barBackgroundView {
            let backgroundView = barBackgroundView.viewWithTag(1) ?? {
                let view = UIView()
                view.tag = 1
                barBackgroundView.addSubview(view)
                return view
            }()
            
            barBackgroundView.bringSubviewToFront(backgroundView)
            backgroundView.frame = barBackgroundView.bounds
            backgroundView.backgroundColor = barTintColor ?? .black
            barBackgroundView.backgroundColor = .clear
        }
        
        isTranslucent = true
        set(alpha: 0)
    }
    
    func setupTitleContainer() {
        if titleLabel == nil, let titleText = appearer?.appearingTitle {
            customTitleContainer = UIView(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height)))
            customTitleContainer?.backgroundColor = .clear
            customTitleContainer?.clipsToBounds = true
            topItem?.titleView = customTitleContainer
            
            titleLabel = UILabel(frame: CGRect(x: 0, y: frame.height, width: customTitleContainer!.frame.width, height: frame.height))
            titleLabel?.textAlignment = .center
            titleLabel?.text = titleText
            titleLabel?.textColor = tintColor ?? .white
            titleLabel?.numberOfLines = 0
            titleLabel?.minimumScaleFactor = 0.5
            titleLabel?.adjustsFontSizeToFitWidth = true
            customTitleContainer!.addSubview(titleLabel!)
            
            customTitleContainer?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["titleLabel" : titleLabel!]))
            customTitleContainer?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["titleLabel" : titleLabel!]))
        }
    }
}


//MARK: - Сalculation
private extension MFAppearingNavigationBar {
    
    func setupForNew(yOffset: CGFloat) {
        guard topItem != nil else {
            return
        }
        
        var yFullOffset = yOffset + frame.height
        if #available(iOS 11.0, *) {
            yFullOffset += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        
        let startAppearingOffset = appearer?.navigationBarStartAppearingOffset ?? 0
        let endAppearingOffset = appearer?.navigationBarEndAppearingOffset ?? startAppearingOffset
        
        if yFullOffset < startAppearingOffset {
            set(alpha: 0)
        } else if yFullOffset > endAppearingOffset {
            set(alpha: 1)
            
        } else if yFullOffset > startAppearingOffset, yFullOffset < endAppearingOffset {
            let currentDiff = yFullOffset - startAppearingOffset
            let max = endAppearingOffset - startAppearingOffset
            set(alpha: currentDiff / max)
        }
        
        updateTitleLabelAppearing(offsetY: yFullOffset)
    }
}


//MARK: - UIChanges
private extension MFAppearingNavigationBar {
    
    func set(alpha: CGFloat) {
        guard frame.size != .zero else {
            return
        }
        
        barBackgroundView?.alpha = alpha
        switch alpha {
        case 0:
            appearingState = .disappeared
            
        case 1:
            appearingState = .appeared
            
        default:
            appearingState = .appearing
        }
    }
    
    func updateTitleLabelAppearing(offsetY: CGFloat) {
        guard let titleLabel = titleLabel else {
            return
        }
        
        if titleAppearingAnimated {
            if appearingState == .appeared {
                UIView.animate(withDuration: animationDuration) {
                    titleLabel.frame.origin.y = titleLabel.superview!.center.y - titleLabel.frame.size.height / 2
                }
            } else if appearingState == .disappeared {
                titleLabel.frame.origin.y = frame.size.height
            }
            
        } else if appearer?.appearingTitleEndOffsetAfterAppearingNavBar != nil {
            updateTitleLabelOrigin(offsetY: offsetY)
            
        } else {
            var frame = titleLabel.frame
            frame.origin.y = titleLabel.superview!.center.y - frame.size.height / 2
            titleLabel.frame = frame
        }
    }
    
    func updateTitleLabelOrigin(offsetY: CGFloat) {
        guard let titleLabel = titleLabel else {
            return
        }
        
        let startTitleAppearingOffset = [appearer?.appearingTitleStartOffsetAfterAppearingNavBar, appearer?.navigationBarEndAppearingOffset, frame.size.height].compactMap { $0 }.first!
        let endTitleAppearingOffset = appearer?.appearingTitleEndOffsetAfterAppearingNavBar ?? startTitleAppearingOffset
        let titleFrame = titleLabel.frame
        let minSpacing = (frame.height - titleFrame.height) / 2
        let way = frame.height - minSpacing
        
        if offsetY < startTitleAppearingOffset {
            titleLabel.frame = CGRect(x: titleFrame.minX, y: frame.height, width: titleFrame.width, height: titleFrame.height)
            
        } else if offsetY > endTitleAppearingOffset {
            titleLabel.frame = CGRect(x: titleFrame.minX, y: minSpacing, width: titleFrame.width, height: titleFrame.height)
            
        } else if offsetY > startTitleAppearingOffset, offsetY < endTitleAppearingOffset {
            let currentDiff = offsetY - startTitleAppearingOffset
            let max = endTitleAppearingOffset - startTitleAppearingOffset
            let currentProcent = currentDiff / max
            let titleOffset = minSpacing + way * (1 - currentProcent)
            
            titleLabel.frame = CGRect(x: titleFrame.minX, y: titleOffset, width: titleFrame.width, height: titleFrame.height)
        }
    }
}
