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
                                    xStep: Int, xBorder: Int, yStep: Int, yBorder: Int, xPercentageStep: Bool, yPercentageStep: Bool) -> Properties? {
        var properties: Properties?
         
        if 0 < numbersCount {
            let xProperties = calculateXProperties(gridRect: gridRect, numbersCount: numbersCount, step: xStep, border: xBorder, percentageStep: xPercentageStep)
            let yProperties = calculateYProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, step: yStep, border: yBorder, percentageStep: yPercentageStep)
             
            properties = Properties(xPropertis: xProperties, yPropertis: yProperties)
        }
         
        return properties
    }
     
    private static func calculateXProperties(gridRect: CGRect, numbersCount: Int, step: Int, border: Int, percentageStep: Bool) -> XProperties {
        let calculateCount: (Int, Int) -> Int = { (numbersCount: Int, step: Int) -> Int in
            var max = numbersCount
            if numbersCount % step != 0 {
                max += step - max % step
            }
            
            return max
        }
        
        var xProperties: XProperties!
        
        var partsCount = numbersCount < step ? 1 : step
        var count = calculateCount(numbersCount, partsCount)
        
        if percentageStep {
            if border < count {
                partsCount *= (count / border + 1)
                count = calculateCount(numbersCount, partsCount)
            }
        }
        
        let width = CGFloat(count * partsCount)
        let partsWidth = gridRect.width / width
        let graphCenter = gridRect.minX
         
        xProperties = XProperties(count: count, partsCount: partsCount, graphCenter: graphCenter, partsWidth: partsWidth)
        
        return xProperties
    }
     
    private static func calculateYProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, step: Int, border: Int, percentageStep: Bool) -> YProperties {
        let calculateMinMax: (Int, inout Int, inout Int) -> () = { (partsCount: Int, min: inout Int, max: inout Int) -> () in
            if 0 < max {
                 max += partsCount - max % partsCount
             }

             if min < 0 {
                 min += partsCount - min % partsCount
             }
        }
        
    
        var yProperties: YProperties!
        
        var partsCount = step
           
        var max = numberMax == Float(Int(numberMax)) ? Int(numberMax) + 1 : Int(ceilf(numberMax))
        var min = 0

        if numberMin < 0 {
            min = numberMin == Float(Int(numberMin)) ? Int(numberMin) - 1 : Int(floorf(numberMin))
        }
        
        var count = abs(max - min)
        
        if 1 < partsCount {
            if 0 < max {
                max += partsCount - max % partsCount
            }

            if min < 0 {
                min -= partsCount + min % partsCount
            }
        }

        count = abs(max - min)
        
        if percentageStep {
            if border < abs(min) || border < max {
                partsCount *= (count / border + 1)
                max += partsCount - max % partsCount
                
                if min < 0 {
                    min -= partsCount + min % partsCount
                }
                
                count = abs(max - min)
            }
        }
        
        let height = CGFloat(count * partsCount)
        let partsHeight = gridRect.height / height
        let graphCenter = gridRect.minY + partsHeight * CGFloat(max * partsCount)
         
        yProperties = YProperties(count: count, partsCount: partsCount, max: max, min: min, graphCenter: graphCenter, partsHeight: partsHeight)
        
        return yProperties
    }
}
