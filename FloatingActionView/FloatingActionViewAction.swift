//
//  FloatingActionViewAction.swift
//  FloatingActionView
//
//  Created by hidemune on 12/14/18.
//  Copyright © 2018 hidemune. All rights reserved.
//

import UIKit

public class FloatingActionViewAction {
    fileprivate let id = UUID()
    let actionColor: UIColor
    let actionImage: UIImage?
    let hintText: String
    let handler: ((FloatingActionViewAction) -> Void)?
    
    public init(actionColor: UIColor, actionImage: UIImage?, hintText: String, handler: ((FloatingActionViewAction) -> Void)?) {
        self.actionColor = actionColor
        self.actionImage = actionImage
        self.hintText = hintText
        self.handler = handler
    }
}

extension FloatingActionViewAction: Equatable {
    public static func == (lhs: FloatingActionViewAction, rhs: FloatingActionViewAction) -> Bool {
        return lhs.id == rhs.id
    }
}
