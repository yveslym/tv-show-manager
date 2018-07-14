//
//  Gradient.swift
//  Tv show app
//
//  Created by Yveslym on 7/14/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import UIKit

class Gradient: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func makeGradient(topColor: UIColor, bottomColor: UIColor){
        
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        
        
        gradient.cornerRadius = layer.cornerRadius
        gradient.shadowRadius = layer.shadowRadius
        gradient.shadowOpacity = layer.shadowOpacity
        gradient.shadowColor = layer.shadowColor
        gradient.borderWidth = layer.borderWidth
        gradient.borderColor = layer.borderColor
        gradient.masksToBounds = layer.masksToBounds
        
        gradient.colors = [topColor, bottomColor].map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        layer.backgroundColor = gradient.backgroundColor
        //layer.addSublayer(gradient)
    }
    
}
