//
//  FloatingActionViewHintView.swift
//  FloatingActionViewExample
//
//  Created by hidemune on 12/20/18.
//  Copyright © 2018 Hidemune Takahashi. All rights reserved.
//

import UIKit

class FloatingActionViewHintView: UIView {
    fileprivate let triangleView: FloatingActionViewHintViewTriangleView = {
        let view = FloatingActionViewHintViewTriangleView()
        return view
    }()
    
    fileprivate let textView: FloatingActionViewHintViewTextView = {
        let view = FloatingActionViewHintViewTextView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(triangleView)
        addSubview(textView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func configure(with action: FloatingActionViewAction) {
        textView.text = action.hintText
        setNeedsDisplay()
    }
    
    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }
    
    override public func updateConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[triangleView(\(10))]",
            options: [],
            metrics: nil,
            views: ["triangleView" : triangleView])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[triangleView(\(20))]",
            options: [],
            metrics: nil,
            views: ["triangleView" : triangleView])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[textView]-0-[triangleView]-0-|",
            options: [],
            metrics: nil,
            views: ["textView" : textView,
                    "triangleView": triangleView])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[textView]-0-|",
            options: [],
            metrics: nil,
            views: ["textView" : textView])
        constraints += [NSLayoutConstraint(
            item: triangleView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: textView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)]
   
        addConstraints(constraints)
        
        super.updateConstraints()
    }
}

fileprivate class FloatingActionViewHintViewTextView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var text: String? {
        didSet {
            label.text = text
            label.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.black
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }
    
    override open class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }
    
    override public func updateConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[label]-8-|",
            options: [],
            metrics: nil,
            views: ["label" : label])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[label]-8-|",
            options: [],
            metrics: nil,
            views: ["label" : label])

        addConstraints(constraints)
        
        super.updateConstraints()
    }
}


fileprivate class FloatingActionViewHintViewTriangleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height / 2))
        bezierPath.addLine(to: CGPoint(x: 0, y: frame.size.height))
        
        UIColor.black.setStroke()
        UIColor.black.setFill()
        
        bezierPath.stroke()
        bezierPath.fill()
    }
}
