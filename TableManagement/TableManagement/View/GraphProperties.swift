//
//  GraphProperties.swift
//  TableManagement
//
//  Created by Admin on 02.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

enum GraphProperties {
    struct XProperties {
        var count: Int
        var partsCount: Int
        var graphCenter: CGFloat
        var partsWidth: CGFloat
    }
    
    struct YProperties {
        var count: Int
        var partsCount: Int
        var max: Int
        var min: Int
        var graphCenter: CGFloat
        var partsHeight: CGFloat
    }
    
    struct Properties {
        var xCount: Int {
            return xPropertis.count
        }
        
        var yCount: Int {
            return yPropertis.count
        }
        
        var xPartsCount: Int {
            return xPropertis.partsCount
        }
        
        var yPartsCount: Int {
            return yPropertis.partsCount
        }
        
        var yMax: Int {
            return yPropertis.max
        }
        
        var yMin: Int {
            return yPropertis.min
        }
        
        var graphCenterX: CGFloat {
            return xPropertis.graphCenter
        }
        
        var graphCenterY: CGFloat {
            return yPropertis.graphCenter
        }
        
        var partsWidth: CGFloat {
            return xPropertis.partsWidth
        }
        
        var partsHeight: CGFloat {
            return yPropertis.partsHeight
        }
        
        private var xPropertis: XProperties
        private var yPropertis: YProperties
        
        init(xCount: Int, yCount: Int, xPartsCount: Int, yPartsCount: Int, yMax: Int, yMin: Int,
             graphCenterX: CGFloat, graphCenterY: CGFloat, partsWidth: CGFloat, partsHeight: CGFloat) {
            xPropertis = XProperties(count: xCount, partsCount: xPartsCount, graphCenter: graphCenterX, partsWidth: partsWidth)
            yPropertis = YProperties(count: yCount, partsCount: yPartsCount, max: yMax, min: yMin, graphCenter: graphCenterY, partsHeight: partsHeight)
        }
        
        init(xPropertis: XProperties, yPropertis: YProperties) {
            self.xPropertis = xPropertis
            self.yPropertis = yPropertis
        }
    }
    
    static func calculateProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, numbersCount: Int,
                                    xStep: Int, yStep: Int, xPercentageStep: Bool, yPercentageStep: Bool) -> Properties? {
        var properties: Properties?
         
        if 0 < numbersCount {
            let xProperties = calculateXProperties(gridRect: gridRect, numbersCount: numbersCount, step: xStep, percentageStep: xPercentageStep)
            let yProperties = calculateYProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, step: yStep, percentageStep: yPercentageStep)
             
            properties = Properties(xPropertis: xProperties, yPropertis: yProperties)
        }
         
        return properties
    }
     
    private static func calculateXProperties(gridRect: CGRect, numbersCount: Int, step: Int, percentageStep: Bool) -> XProperties {
        var xProperties: XProperties!
        
        var partsCount = 1
        
        if percentageStep {
            if step < numbersCount {
                let partLen = numbersCount / step
                
                partsCount = -(partLen + step - partLen % step)
            }
        }
        else {
            if step < numbersCount {
                partsCount = -step
            }
        }
        
        var max = numbersCount
        let absPartsCount = abs(partsCount)
        if partsCount < -1 {
            max += absPartsCount - max % absPartsCount
        }

        let count = max
        let width = CGFloat(count * absPartsCount)
        let partsWidth = gridRect.width / width
        let graphCenter = gridRect.minX
         
        xProperties = XProperties(count: count, partsCount: absPartsCount, graphCenter: graphCenter, partsWidth: partsWidth)
        
        return xProperties
    }
     
    private static func calculateYProperties(gridRect: CGRect, numberMax: Float, numberMin: Float,  step: Int, percentageStep: Bool) -> YProperties {
        var yProperties: YProperties!
        
        var partsCount = 1
           
        var max = numberMax == Float(Int(numberMax)) ? Int(numberMax) + 1 : Int(ceilf(numberMax))
        var min = 0

        if numberMin < 0 {
            min = numberMin == Float(Int(numberMin)) ? Int(numberMin) - 1 : Int(floorf(numberMin))
        }
        
        var count = abs(max - min)
        
        if percentageStep {
            if step < count {
                let partLen = count / step

                partsCount = -(partLen + step - partLen % step)
            }
        }
        else {
            if step < count {
                partsCount = -step
            }
        }
        
        let absPartsCount = abs(partsCount)
        if partsCount < -1 {
            if 0 < max {
                max += absPartsCount - max % absPartsCount
            }

            if min < 0 {
                min += partsCount - min % partsCount
            }
        }

        count = max - min
        
        let height = CGFloat(count * absPartsCount)
        let partsHeight = gridRect.height / height
        let graphCenter = gridRect.minY + partsHeight * CGFloat(max * absPartsCount)
         
        yProperties = YProperties(count: count, partsCount: absPartsCount, max: max, min: min, graphCenter: graphCenter, partsHeight: partsHeight)
        
        return yProperties
    }
}
