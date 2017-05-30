//
//  UIImage+Blur.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/28/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
extension UIImageView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
