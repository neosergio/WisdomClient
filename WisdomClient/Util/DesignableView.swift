//
//  DesignableView.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/12/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
