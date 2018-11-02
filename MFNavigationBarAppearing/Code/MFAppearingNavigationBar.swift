//
//  MFAppearingNavigationBar.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit


open class MFAppearingNavigationBar: UINavigationBar {
    
    open private(set) var titleLabel: UILabel?
    open private(set) var appearingState: AppearingState = .disappeared
    open var navigationBarColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }
    
    open override var tintColor: UIColor! {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var titleAppearingInteractive = true
    open var titleAppearingAnimated = false {
        didSet {
            titleAppearingInteractive = !titleAppearingAnimated
        }
    }
    
    open var animationDuration: TimeInterval = 0.33
    open weak var appearer: MFNavigationBarAppearer?
    
    private var barBackgroundView: UIView?
    private var observation: NSKeyValueObservation?
        
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        
        if topItem?.titleView == nil {
            setupTitleContainer()
        }
        
        if let scrollView = appearer?.appearingScrollView {
            observation = scrollView.observe(\.contentOffset, changeHandler: { [weak self] (scrollView, change) in
                self?.setupForNew(yOffset: scrollView.contentOffset.y)
            })
        }
    }
}


//MARK: - AppearingState
public extension MFAppearingNavigationBar {
    
    enum AppearingState: RawRepresentable {
        public typealias RawValue = CGFloat
        
        case appeared, disappeared, appearing
        
        public init(rawValue: CGFloat) {
            switch rawValue {
            case 0:
                self = .disappeared
                
            case 1:
                self = .appeared
                
            default:
                self = .appearing
            }
        }
        
        public var rawValue: CGFloat {
            switch self {
            case .disappeared:
                return 0
                
            case .appeared:
                return 1
                
            default:
                return 0.5
            }
        }
    }
}


//MARK: - Configuretions
private extension MFAppearingNavigationBar {
    
    func setupUI() {
        barBackgroundView = subviews.first
        barBackgroundView?.backgroundColor = navigationBarColor ?? .black
        titleLabel?.textColor = tintColor ?? .white
        
        if let barBackgroundView = barBackgroundView {
            let backgroundView = barBackgroundView.viewWithTag(1) ?? {
                let view = UIView()
                view.tag = 1
                barBackgroundView.addSubview(view)
                return view
            }()
            
            barBackgroundView.bringSubviewToFront(backgroundView)
            backgroundView.frame = barBackgroundView.bounds
            backgroundView.backgroundColor = barBackgroundView.backgroundColor
            barBackgroundView.backgroundColor = .clear
        }
        
        isTranslucent = true
        set(alpha: 0)
    }
    
    func setupTitleContainer() {
        if titleLabel == nil, let titleText = appearer?.appearingTitle {
            let containerView = MFLabelView(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height)))
            containerView.clipsToBounds = true
            containerView.navigationBar = self
            
            titleLabel = containerView.label
            titleLabel?.text = titleText
            titleLabel?.textColor = tintColor ?? .white
            topItem?.titleView = containerView
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
        appearingState = AppearingState(rawValue: alpha)
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
