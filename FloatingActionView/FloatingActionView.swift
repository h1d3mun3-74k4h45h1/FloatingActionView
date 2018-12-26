//
//  FloatingActionView.swift
//  FloatingActionView
//
//  Created by hidemune on 12/14/18.
//  Copyright © 2018 hidemune. All rights reserved.
//

import UIKit

public class FloatingActionView: UIView {
    public var menuButtonIcon: UIImage? = nil {
        didSet {
            menuButton.setImage(menuButtonIcon, for: .normal)
            menuButton.setNeedsDisplay()
        }
    }
    
    public var menuButtonIconColor: UIColor = UIColor.clear {
        didSet {
            menuButton.backgroundColor = menuButtonIconColor
            menuButton.setNeedsDisplay()
        }
    }
    
    public var menuButtonSize: CGFloat = 44.0 {
        didSet {
            menuButton.layer.cornerRadius = menuButtonSize / 2
            self.setNeedsUpdateConstraints()
        }
    }
    
    fileprivate var actionButtonSize: CGFloat {
        return menuButtonSize * 0.8
    }
    
    public var actionButtonSpacing: CGFloat  = 8.0
    
    public var actionBorderColor = UIColor.black {
        didSet {
            createHintViews()
        }
    }
    
    public var actionFillColor =  UIColor.black {
        didSet {
            createHintViews()
        }
    }
    
    public var actionHasBorder: Bool = false {
        didSet {
            createHintViews()
        }
    }
    
    public var actionHasRound: Bool = false {
        didSet {
            createHintViews()
        }
    }
    
    public var actionTextColor = UIColor.white {
        didSet {
            createHintViews()
        }
    }
    
    fileprivate let menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 44/2
        button.addTarget(self,
                         action: #selector(FloatingActionView.menuButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate var expanded: Bool = false {
        didSet {
            animate()
        }
    }
    
    fileprivate var actions = [FloatingActionViewAction]([]) {
        didSet {
            createActionButtons()
            createHintViews()
        }
    }
    
    fileprivate var actionButtons = [UIButton]([])
    fileprivate var hintViews = [FloatingActionViewHintView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }
    
    override public func updateConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[menuButton(\(menuButtonSize))]",
            options: [],
            metrics: nil,
            views: ["menuButton" : menuButton])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[menuButton(\(menuButtonSize))]",
            options: [],
            metrics: nil,
            views: ["menuButton" : menuButton])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[menuButton]-0-|",
            options: [],
            metrics: nil,
            views: ["menuButton" : menuButton])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[menuButton]-0-|",
            options: [],
            metrics: nil,
            views: ["menuButton" : menuButton])
        
        addConstraints(constraints)
        
        super.updateConstraints()
    }
    
    public override func didMoveToSuperview() {
        guard let superView = self.superview else { fatalError() }
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[self]-8-|",
            options: [],
            metrics: nil,
            views: ["self" : self])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[self]-8-|",
            options: [],
            metrics: nil,
            views: ["self" : self])
        
        superView.addConstraints(constraints)
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if expanded {
            var tappedButton: UIButton? = nil
            var tappedPoint: CGPoint? = nil
            actionButtons.forEach { actionButton in
                let converted: CGPoint = actionButton.convert(point, from: self)
                if actionButton.bounds.contains(converted) {
                    tappedButton = actionButton
                    tappedPoint = converted
                }
            }
            
            if let tappedButton = tappedButton,
                let tappedPoint = tappedPoint {
                return tappedButton.hitTest(tappedPoint, with:event)
            } else {
                return super.hitTest(point, with: event)
            }
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    public func addAction(_ action: FloatingActionViewAction) {
        actions.append(action)
    }
}

extension FloatingActionView {
    fileprivate func commonInit() {
        setupSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
    }
    
    fileprivate func setupSubviews() {
        addSubview(menuButton)
    }
    
    fileprivate func createActionButtons() {
        actionButtons.forEach({ $0.removeFromSuperview() })
        actionButtons = []
        
        actionButtons = actions.compactMap({ return createActionButton(of: $0) })
        actionButtons.forEach({ addSubview($0) })
    }
    
    fileprivate func createHintViews() {
        hintViews.forEach({ $0.removeFromSuperview() })
        hintViews = []
        
        hintViews = actions.compactMap({ return createHintView($0) })
        hintViews.forEach({ addSubview($0) })
    }
    
    fileprivate func animate() {
        if expanded {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                for(actionButton, hintView) in zip(self.actionButtons, self.hintViews) {
                    actionButton.alpha = 1.0
                    hintView.alpha = 1.0
                    guard let index = self.actionButtons.firstIndex(of: actionButton) else { fatalError("Unknown Button Exist!") }
                    actionButton.frame = self.calculateActionButtonAnimatedRect(buttonIndex: index + 1)
                    hintView.frame = self.calculateHintViewAnimatedRect(hintView: hintView, index: index + 1)
                    self.layoutIfNeeded()
                }
            }
        } else {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                for(actionButton, hintView) in zip(self.actionButtons, self.hintViews) {
                    actionButton.frame = self.calculateActionButtonInitialRect()
                    hintView.frame = self.calculateHintViewInitialRect(hintView: hintView)
                    actionButton.alpha = 0.0
                    hintView.alpha = 0.0
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    fileprivate func calculateActionButtonInitialRect() -> CGRect {
        return CGRect(x: menuButtonSize * 0.1,
                      y: menuButtonSize * 0.1,
                      width: actionButtonSize,
                      height: actionButtonSize)
    }
    
    fileprivate func calculateHintViewInitialRect(hintView: FloatingActionViewHintView) -> CGRect {
        return CGRect(x: 0 - hintView.frame.size.width,
                      y: 0,
                      width: hintView.frame.size.width,
                      height: hintView.frame.size.height)
    }
    
    fileprivate func calculateActionButtonAnimatedRect(buttonIndex: Int) -> CGRect  {
        return CGRect(x: menuButtonSize * 0.1,
                      y: 0 - actionButtonSpacing * CGFloat(buttonIndex) - actionButtonSize * CGFloat(buttonIndex),
                      width: actionButtonSize,
                      height: actionButtonSize)
    }
    
    fileprivate func calculateHintViewAnimatedRect(hintView: FloatingActionViewHintView, index: Int) -> CGRect {
        let centerPoint = CGPoint(x: 0,
                                  y: 0 - actionButtonSpacing * CGFloat(index) - actionButtonSize * CGFloat(index) + actionButtonSize / 2)
        return CGRect(x: centerPoint.x - hintView.frame.width,
                      y: centerPoint.y - hintView.frame.height / 2,
                      width: hintView.frame.width,
                      height: hintView.frame.height)
    }
    
    fileprivate func createActionButton(of action: FloatingActionViewAction) -> UIButton {
        let button = UIButton(frame: calculateActionButtonInitialRect())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = action.actionColor
        button.setImage(action.actionImage, for: .normal)
        button.layer.cornerRadius = actionButtonSize / 2
        button.addTarget(self,
                         action: #selector(FloatingActionView.actionButtonTapped(sender:)),
                         for: .touchUpInside)
        button.alpha = 0.0
        return button
    }
    
    fileprivate func createHintView(_ action: FloatingActionViewAction) -> FloatingActionViewHintView {
        let hintView = FloatingActionViewHintView()
        hintView.configure(with: action, actionView: self)
        hintView.alpha = 0.0
        return hintView
    }
}

extension FloatingActionView {
    @objc fileprivate func menuButtonTapped() {
        expanded = !expanded
    }
    
    
    @objc fileprivate func actionButtonTapped(sender: AnyObject) {
        guard let button = sender as? UIButton,
            let actionIndex = actionButtons.firstIndex(of: button) else { return }
        let action = actions[actionIndex]
        if let handler = action.handler {
            handler(action)
        }
        expanded = false
    }
}

