//
//  FloatingActionViewHintView.swift
//  FloatingActionViewExample
//
//  Created by hidemune on 12/20/18.
//  Copyright © 2018 Hidemune Takahashi. All rights reserved.
//

import UIKit

class FloatingActionViewHintView: UIView {
    enum DrawMode {
        case fillAll
        case fillAndBorder
    }
    
    fileprivate var drawMode = FloatingActionViewHintView.DrawMode.fillAll {
        didSet {
            switch drawMode {
            case .fillAll:
                triangleView.lineMode = .drawAll
                textView.hasBorder = false
            case .fillAndBorder:
                triangleView.lineMode = .drawRoof
                textView.hasBorder = true
            }
        }
    }
    
    fileprivate var fillColor = UIColor.black {
        didSet {
            triangleView.fillColor = fillColor
            textView.backgroundColor = fillColor
        }
    }
    
    fileprivate var lineColor = UIColor.white {
        didSet {
            triangleView.lineColor = lineColor
            textView.lineColor = lineColor
        }
    }
    
    fileprivate var textColor = UIColor.white {
        didSet {
            textView.textColor = textColor
        }
    }
    
    fileprivate var lineWidth: CGFloat = 2.0 {
        didSet {
            triangleView.lineWidth = lineWidth
            textView.lineWidth = lineWidth
        }
    }
    
    fileprivate let triangleView = FloatingActionViewHintViewTriangleView()
    fileprivate let textView = FloatingActionViewHintViewTextView()
    
    private var innerGap: CGFloat {
        return lineWidth * 2 * -1
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
        addSubview(triangleView)
        addSubview(textView)
        bringSubviewToFront(triangleView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func configure(with action: FloatingActionViewAction, actionView: FloatingActionView) {
        textView.text = action.hintText
        if actionView.actionHasBorder {
            lineColor = actionView.actionBorderColor
            fillColor = actionView.actionFillColor
        } else {
            lineColor = actionView.actionFillColor
            fillColor = actionView.actionFillColor
        }
        textColor = actionView.actionTextColor
        if actionView.actionHasBorder {
            drawMode = .fillAndBorder
        } else {
            drawMode = .fillAll
        }
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
            withVisualFormat: "H:|-0-[textView]-(\(innerGap))-[triangleView]-0-|",
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

class FloatingActionViewHintViewTextView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var text: String? {
        didSet {
            label.text = text
            label.setNeedsDisplay()
        }
    }
    
    fileprivate var textColor = UIColor.white {
        didSet {
            label.textColor = textColor
            label.setNeedsDisplay()
        }
    }
    
    fileprivate var hasBorder: Bool = false {
        didSet {
            updateBorder()
            setNeedsDisplay()
        }
    }
    
    fileprivate var lineColor = UIColor.black {
        didSet {
            updateBorder()
            setNeedsDisplay()
        }
    }
    
    fileprivate var lineWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
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
    
    private func updateBorder() {
        if hasBorder {
            layer.borderColor = lineColor.cgColor
            layer.borderWidth = lineWidth
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0.0
        }
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
    enum LineMode {
        case drawAll
        case drawRoof
    }
    
    var lineColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fillColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineMode = FloatingActionViewHintViewTriangleView.LineMode.drawAll {
        didSet {
            setNeedsDisplay()
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
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        drawInnerTriangle()
        drawLine()
    }
    
    private func drawInnerTriangle() {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint.init(x: lineWidth, y: lineWidth))
        bezierPath.addLine(to: CGPoint(x: frame.size.width -  lineWidth, y: frame.size.height / 2))
        bezierPath.addLine(to: CGPoint(x: lineWidth, y: frame.size.height - lineWidth))
        fillColor.setFill()
        bezierPath.fill()
    }
    
    private func drawLine() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.init(x: lineWidth, y: lineWidth))
        bezierPath.addLine(to: CGPoint(x: frame.size.width -  lineWidth, y: frame.size.height / 2))
        bezierPath.addLine(to: CGPoint(x: lineWidth, y: frame.size.height - lineWidth))
        
        lineColor.setStroke()
        bezierPath.lineWidth = lineWidth
        
        if lineMode == .drawAll {
            bezierPath.close()
        }
        
        bezierPath.stroke()
    }
}
