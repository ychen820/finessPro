//
//  ScrollableGraphView+Styles.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/23/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
extension ScrollableGraphView{
    func smoothDarkSetup(){
        backgroundFillColor = UIColor.colorFromHex("#333333")
        
        rangeMax = 50
        
        lineWidth = 1
        lineColor = UIColor.colorFromHex("#777777")
        lineStyle = ScrollableGraphViewLineStyle.smooth
        
        shouldFill = true
        fillType = ScrollableGraphViewFillType.gradient
        fillColor = UIColor.colorFromHex("#555555")
        fillGradientType = ScrollableGraphViewGradientType.linear
        fillGradientStartColor = UIColor.colorFromHex("#555555")
        fillGradientEndColor = UIColor.colorFromHex("#444444")
        shouldAutomaticallyDetectRange = true
        dataPointSpacing = 80
        dataPointSize = 2
        dataPointFillColor = UIColor.white
        
        referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLineLabelColor = UIColor.white
        dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

    }
}
