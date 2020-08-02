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
        var partition: Int
        var graphCenter: CGFloat
        var partsWidth: CGFloat
    }
    
    struct YProperties {
        var count: Int
        var partition: Int
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
        
        var xPartition: Int {
            return xPropertis.partition
        }
        
        var yPartition: Int {
            return yPropertis.partition
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
        
        init(xCount: Int, yCount: Int, xPartition: Int, yPartition: Int, yMax: Int, yMin: Int,
             graphCenterX: CGFloat, graphCenterY: CGFloat, partsWidth: CGFloat, partsHeight: CGFloat) {
            xPropertis = XProperties(count: xCount, partition: xPartition, graphCenter: graphCenterX, partsWidth: partsWidth)
            yPropertis = YProperties(count: yCount, partition: yPartition, max: yMax, min: yMin, graphCenter: graphCenterY, partsHeight: partsHeight)
        }
        
        init(xPropertis: XProperties, yPropertis: YProperties) {
            self.xPropertis = xPropertis
            self.yPropertis = yPropertis
        }
    }
    
    static func calculateProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, numbersCount: Int,
                                    cellWidth: CGFloat, cellHeight: CGFloat) -> Properties? {
        var properties: Properties?
         
        if 0 < numbersCount {
            let xProperties = calculateXProperties(gridRect: gridRect, numbersCount: numbersCount, cellWidth: cellWidth)
            let yProperties = calculateYProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, cellHeight: cellHeight)
            
            print(yProperties.min)
            print(yProperties.max)
             
            properties = Properties(xPropertis: xProperties, yPropertis: yProperties)
        }
         
        return properties
    }
     
    private static func calculateXProperties(gridRect: CGRect, numbersCount: Int, cellWidth: CGFloat) -> XProperties {
        var xProperties: XProperties!
         
        var xPropertiesMin: XProperties!
        var xPropertiesMax: XProperties!
         
        var partition = 0
        var partitionPrev = 0
         
        var cellWidthMin: CGFloat = 0
        var cellWidthMax: CGFloat = 0
         
        repeat {
            let partsCount = partitionToPartsCount(partition: partition, partitionPrev: partitionPrev)
             
            var max = numbersCount
            let absPartsCount = abs(partsCount)
            if partsCount < -1 {
                max += absPartsCount - max % absPartsCount
            }

            let count = max
            let width = CGFloat(count * absPartsCount)
            let partsWidth = gridRect.width / width
            let graphCenter = gridRect.minX
             
            xProperties = XProperties(count: count, partition: partition, graphCenter: graphCenter, partsWidth: partsWidth)
            let partitionCellWidth = partsCount < 0 ? partsWidth * CGFloat(partsCount * partsCount) :partsWidth / CGFloat(partsCount * partsCount)
             
            partitionPrev = partition
            if cellWidth < partitionCellWidth {
                xPropertiesMin = xProperties
                cellWidthMin = partitionCellWidth
                partition += 1
            }
            else {
                xPropertiesMax = xProperties
                cellWidthMax = partitionCellWidth
                partition -= 1
            }
             
            if cellWidthMax != 0 && cellWidthMin != 0 {
                let widthMin = cellWidth - cellWidthMin
                let widthMax = cellWidthMax - cellWidth
                 
                if widthMin < widthMax {
                    xProperties = xPropertiesMin
                }
                else {
                    xProperties = xPropertiesMax
                }
            }
        } while cellWidthMax == 0 || cellWidthMin == 0
         
        return xProperties
    }
     
    private static func calculateYProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, cellHeight: CGFloat) -> YProperties {
        var yProperties: YProperties!
         
        var yPropertiesMin: YProperties!
        var yPropertiesMax: YProperties!
         
        var partition = 0
        var partitionPrev = 0
         
        var cellHeightMin: CGFloat = 0
        var cellHeightMax: CGFloat = 0
         
        repeat {
            let partsCount = partitionToPartsCount(partition: partition, partitionPrev: partitionPrev)
             
            var max = numberMax == Float(Int(numberMax)) ? Int(numberMax) + 1 : Int(ceilf(numberMax))
            var min = 0

            if numberMin < 0 {
                min = numberMin == Float(Int(numberMin)) ? Int(numberMin) - 1 : Int(floorf(numberMin))
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

            let count = max - min
            let height = CGFloat(count * absPartsCount)
            let partsHeight = gridRect.height / height
            let graphCenter = gridRect.minY + partsHeight * CGFloat(max * absPartsCount)
             
            yProperties = YProperties(count: count, partition: partition, max: max, min: min, graphCenter: graphCenter, partsHeight: partsHeight)
            let partitionCellHeight = partsCount < 0 ? partsHeight * CGFloat(partsCount * partsCount) : partsHeight / CGFloat(partsCount * partsCount)
             
            partitionPrev = partition
            if cellHeight < partitionCellHeight {
                yPropertiesMin = yProperties
                cellHeightMin = partitionCellHeight
                partition += 1
            }
            else {
                yPropertiesMax = yProperties
                cellHeightMax = partitionCellHeight
                partition -= 1
            }
             
            if cellHeightMax != 0 && cellHeightMin != 0 {
                let heightMin = cellHeight - cellHeightMin
                let heightMax = cellHeightMax - cellHeight
                 
                if heightMin < heightMax {
                    yProperties = yPropertiesMin
                }
                else {
                    yProperties = yPropertiesMax
                }
            }
        } while cellHeightMax == 0 || cellHeightMin == 0
         
        return yProperties
    }
    
    private static func partitionToPartsCount(partition: Int, partitionPrev: Int) -> Int {
        var partsCount = 0
        
        if partition == 0 {
            switch partitionPrev {
            case 1:
                partsCount = -2
                break
            case -1:
                partsCount = 2
                break
            default:
                partsCount = 1
                break
            }
        }
        else {
            partsCount = partition < 0 ? partition - 1 : partition + 1
        }
        
        return partsCount
    }
}
