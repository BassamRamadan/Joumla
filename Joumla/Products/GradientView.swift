//
//  GradientView.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
@IBDesignable
class GradientView: UIView {
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateColor()
        }
    }
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateColor()
        }
    }
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    func updateColor(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
    }
}
