//
//  GraphView.swift
//  TableManagement
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum GraphViewDefaultSettings {
    static let padding:     CGFloat = 10
    static let fontPadding: CGFloat = 8
    
    static let lineWidth:       CGFloat = 1
    static let pointSize:       CGFloat = 2
    static let dashSize:        CGFloat = 3
    static let graphCenterSize: CGFloat = 4
    static let fontSize:        CGFloat = 10
    
    static let captionsPrecision: Int = 2
    
    static let gridColor       = UIColor.lightGray
    static let graphColor      = UIColor.black
    static let positiveColor   = UIColor.red
    static let negativeColor   = UIColor.blue
    static let backgroundColor = UIColor.white
}

private struct GraphProperties {
    var xCount: Int
    var yCount: Int
    
    var xPartition: Int
    var yPartition: Int
    
    var yMax: Int
    var yMin: Int
    
    var graphCenterX: CGFloat
    var graphCenterY: CGFloat
    
    var cellWidth: CGFloat
    var cellHeight: CGFloat
}

class GraphView: UIView {
    var dataSource: GraphViewDataSource!
    
    var padding: CGFloat
    var fontPadding: CGFloat
    
    var lineWidth: CGFloat
    var pointSize: CGFloat
    var dashSize: CGFloat
    var graphCenterSize: CGFloat
    var fontSize: CGFloat
    
    var captionsPrecision: Int
    
    var gridColor: UIColor
    var graphColor: UIColor
    var positiveColor: UIColor
    var negativeColor: UIColor
    
    private var yAxisTextPadding: CGFloat
    
    init() {
        //super.init(frame: .zero)
        
        padding = GraphViewDefaultSettings.padding
        fontPadding = GraphViewDefaultSettings.fontPadding

        lineWidth = GraphViewDefaultSettings.lineWidth
        pointSize = GraphViewDefaultSettings.pointSize
        dashSize = GraphViewDefaultSettings.dashSize
        graphCenterSize = GraphViewDefaultSettings.graphCenterSize
        fontSize = GraphViewDefaultSettings.fontSize
        
        captionsPrecision = GraphViewDefaultSettings.captionsPrecision

        gridColor = GraphViewDefaultSettings.gridColor
        graphColor = GraphViewDefaultSettings.graphColor
        positiveColor = GraphViewDefaultSettings.positiveColor
        negativeColor = GraphViewDefaultSettings.negativeColor
        
        yAxisTextPadding = 0

        super.init(frame: .zero)
        
        //backgroundColor = GraphViewDefaultSettings.backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = GraphViewDefaultSettings.backgroundColor
    }
    
    override func draw(_ rect: CGRect) {
        drawGraph(rect)
    }
    
    private func drawGraph(_ rect: CGRect) {
        if let dataSource = dataSource {
            let numbersCount = dataSource.graphViewDataSourceCount(self)
            
            if 0 < numbersCount {
                var numberMax: Float = 0
                var numberMin: Float = 0
                
                if let max = dataSource.graphViewDataSourceMax(self) {
                    numberMax = max
                }
                
                if let min = dataSource.graphViewDataSourceMin(self) {
                    numberMin = min
                }
                
                yAxisTextPadding = CGFloat(max(GraphView.digitsCount(value: Int(numberMax)),
                                               GraphView.digitsCount(value: Int(numberMin))) + captionsPrecision + 1) * fontPadding

                let gridRect = CGRect(x: padding + yAxisTextPadding,
                                      y: padding + fontPadding,
                                      width: rect.width - 2 * padding - yAxisTextPadding,
                                      height: rect.height - 2 * (padding + fontPadding))
                let graphProperties = GraphView.calculateGraphProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, numbersCount: numbersCount)
                
                if let graphProperties = graphProperties {
                    if let context = UIGraphicsGetCurrentContext() {
                        // Not needed here because the view context is already current?
                        UIGraphicsPushContext(context)
                        
                        drawGrid(context, gridRect: gridRect, graphProperties: graphProperties)
                        drawNumbers(context, graphProperties: graphProperties)
                        
                        UIGraphicsPopContext()
                    }
                }
            }
        }
    }
    
    private func drawGrid(_ context: CGContext, gridRect: CGRect, graphProperties: GraphProperties) {
        let xPartsCount = abs(graphProperties.xPartition) + 1
        let yPartsCount = abs(graphProperties.yPartition) + 1
        
        // X Axis
        if graphProperties.xPartition < 0 {
            // Increasing the grid step
            for i in 0..<graphProperties.xCount {
                if i % xPartsCount == 0 {
                    let stepIndex = i * xPartsCount
                    let xPosition = gridRect.minX + graphProperties.cellWidth * CGFloat(i * xPartsCount)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphProperties.graphCenterY + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphProperties.graphCenterY - dashSize / 2)
                    
                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if stepIndex != 0 {
                        drawString(string: String(stepIndex), point: CGPoint(x: xPosition, y: graphProperties.graphCenterY + fontPadding))
                    }
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.xCount {
                for j in 0..<xPartsCount {
                    let stepIndex = i * xPartsCount + j
                    let xPosition = gridRect.minX + graphProperties.cellWidth * CGFloat(stepIndex)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphProperties.graphCenterY + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphProperties.graphCenterY - dashSize / 2)

                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if stepIndex != 0 {
                        let stepIndexDecrease = Float(stepIndex) / Float(xPartsCount)
                        drawString(string: String(format: "%.\(captionsPrecision)f", stepIndexDecrease),
                                   point: CGPoint(x: xPosition, y: graphProperties.graphCenterY + fontPadding))
                    }
                }
            }
        }
        
        // Y Axis
        if graphProperties.yPartition < 0 {
            // Increasing the grid step
            for i in 0..<graphProperties.yCount {
                if i % yPartsCount == 0 {
                    let yPosition = gridRect.maxY - graphProperties.cellHeight * CGFloat(i * yPartsCount)
                    let horizontalDashBegin = CGPoint(x: graphProperties.graphCenterX + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: graphProperties.graphCenterX - dashSize / 2, y: yPosition)
                    
                    drawLine(context, begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(context, begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                    
                    drawString(string: String(i + graphProperties.yMin), point: CGPoint(x: graphProperties.graphCenterX - yAxisTextPadding, y: yPosition))
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.yCount {
                for j in 0..<yPartsCount {
                    let stepIndex = i * yPartsCount + j
                    let yPosition = gridRect.maxY - graphProperties.cellHeight * CGFloat(stepIndex)
                    let horizontalDashBegin = CGPoint(x: graphProperties.graphCenterX + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: graphProperties.graphCenterX - dashSize / 2, y: yPosition)
                    
                    drawLine(context, begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(context, begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                    
                    let stepIndexDecrease = Float(stepIndex + graphProperties.yMin * yPartsCount) / Float(yPartsCount)
                    drawString(string: String(format: "%.\(captionsPrecision)f", stepIndexDecrease),
                               point: CGPoint(x: graphProperties.graphCenterX - yAxisTextPadding, y: yPosition))
                }
            }
        }
        
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.maxX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.minY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.maxY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        
        if 0 < graphProperties.xCount {
            let graphCenter = CGPoint(x: graphProperties.graphCenterX, y: graphProperties.graphCenterY)
            
            drawPoint(context, point: graphCenter, size: graphCenterSize, color: graphColor)
            drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: graphColor)
            drawLine(context, begin: graphCenter, end: CGPoint(x: gridRect.maxX, y: graphCenter.y), color: graphColor)
            
            if graphCenter.y != gridRect.minY {
                drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY),
                         end: CGPoint(x: gridRect.minX + dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
                drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY),
                         end: CGPoint(x: gridRect.minX - dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
                
                drawString(string: "Y", point: CGPoint(x: gridRect.minX, y: gridRect.minY - fontPadding))
            }
            
            drawLine(context, begin: CGPoint(x: gridRect.maxX, y: graphCenter.y),
                     end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y - dashSize), color: graphColor)
            drawLine(context, begin: CGPoint(x: gridRect.maxX, y: graphCenter.y),
                     end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y + dashSize), color: graphColor)
            
            drawString(string: "X", point: CGPoint(x: gridRect.maxX + fontPadding, y: graphCenter.y))
        }
    }
    
    private func drawNumbers(_ context: CGContext, graphProperties: GraphProperties) {
        if let dataSource = dataSource {
            let numbersCount = dataSource.graphViewDataSourceCount(self)
        
            var positivePoints: [CGPoint] = []
            var negativePoints: [CGPoint] = []
            
            for i in 0..<numbersCount {
                let number = dataSource.graphViewDataSourceNumber(self, at: i)
                let point = GraphView.getGraphPoint(index: i, number: number, graphProperties: graphProperties)
                var color = UIColor()
                
                if number < 0 {
                    negativePoints.append(point)
                    color = negativeColor
                }
                else {
                    positivePoints.append(point)
                    color = positiveColor
                }
                
                drawPoint(context, point: point, size: pointSize, color: color)
            }
            
            drawLines(context, points: negativePoints, color: negativeColor)
            drawLines(context, points: positivePoints, color: positiveColor)
        }
    }
    
    private func drawLines(_ context: CGContext, points: [CGPoint], color: UIColor) {
        context.addLines(between: points)
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.strokePath()
    }
    
    private func drawLine(_ context: CGContext, begin: CGPoint, end: CGPoint, color: UIColor) {
        drawLines(context, points: [begin, end], color: color)
    }
    
    private func drawPoint(_ context: CGContext, point: CGPoint, size: CGFloat, color: UIColor) {
        let pointRect = CGRect(x: point.x - size / 2, y: point.y - size / 2, width: size, height: size)
        
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: pointRect)
    }
    
    private func drawString(string: String, point: CGPoint) {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attribute = [NSAttributedString.Key.font: font]
        let attributedString = NSAttributedString(string: string, attributes: attribute)
        
        attributedString.draw(at: CGPoint(x: point.x - fontSize / 2, y: point.y - fontSize / 2))
    }
    
    private static func calculateGraphProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, numbersCount: Int) -> GraphProperties? {
        let partitionToPartsCount: (Int, Int) -> Int = { (partition: Int, partitionPrev: Int) -> Int in
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
        
        var graphProperties: GraphProperties?
        
        let widthMin: CGFloat = 10
        let widthMax: CGFloat = 100

        let heightMin: CGFloat = 10
        let heightMax: CGFloat = 20
        
        if 0 < numbersCount {
            var xCalculation = true
            var yCalculation = true
            
            var xPartition = 0
            var yPartition = 0
            var xPartitionPrev = 0
            var yPartitionPrev = 0
            
            while xCalculation || yCalculation {
                let xPartsCount = partitionToPartsCount(xPartition, xPartitionPrev)
                let yPartsCount = partitionToPartsCount(yPartition, yPartitionPrev)
                
                // Calculating the X axis width of the grid
                var xMax = numbersCount

                let absXPartsCount = abs(xPartsCount)
                if xPartsCount < -1 {
                    xMax += absXPartsCount - xMax % absXPartsCount
                }

                let xCount = xMax
                let xWidth = CGFloat(xCount * absXPartsCount)

                // Calculating the Y axis width of the grid
                var yMax = numberMax == Float(Int(numberMax)) ? Int(numberMax) + 1 : Int(ceilf(numberMax))
                var yMin = 0
        
                if numberMin < 0 {
                    yMin = numberMin == Float(Int(numberMin)) ? Int(numberMin) - 1 : Int(floorf(numberMin))
                }
                
                let absYPartsCount = abs(yPartsCount)
                if yPartsCount < -1 {
                    if 0 < yMax {
                        yMax += absYPartsCount - yMax % absYPartsCount
                    }

                    if yMin < 0 {
                        yMin += yPartsCount - yMin % yPartsCount
                    }
                }

                let yCount = yMax - yMin
                let yHeight = CGFloat(yCount * absYPartsCount)
                
                let cellWidth = gridRect.width / xWidth
                let cellHeight = gridRect.height / yHeight
                
                let graphCenterX = gridRect.minX
                let graphCenterY = gridRect.minY + cellHeight * CGFloat(yMax * absYPartsCount)
                
                graphProperties = GraphProperties(xCount: xCount, yCount: yCount, xPartition: xPartition, yPartition: yPartition,
                                                  yMax: yMax, yMin: yMin, graphCenterX: graphCenterX, graphCenterY: graphCenterY,
                                                  cellWidth: cellWidth, cellHeight: cellHeight)
                
                // Finding the number of partitions
                let partitionCellWidth = xPartsCount < 0 ? cellWidth * CGFloat(xPartsCount * xPartsCount) : cellWidth / CGFloat(xPartsCount * xPartsCount)
                let partitionCellHeight = yPartsCount < 0 ? cellHeight * CGFloat(yPartsCount * yPartsCount) : cellHeight / CGFloat(yPartsCount * yPartsCount)

                if  widthMin < partitionCellWidth && partitionCellWidth < widthMax {
                    xCalculation = false
                }
                else {
                    xPartitionPrev = xPartition
                    xPartition = widthMax < partitionCellWidth ? xPartition + 1: xPartition - 1
                }

                if  heightMin < partitionCellHeight && partitionCellHeight < heightMax {
                    yCalculation = false
                }
                else {
                    yPartitionPrev = yPartition
                    yPartition = heightMax < partitionCellHeight ? yPartition + 1: yPartition - 1
                }

                print("\(widthMin) < \(partitionCellWidth) < \(widthMax)")
            }
        }
        
        return graphProperties
    }
    
    private static func getGraphPoint(index: Int, number: Float, graphProperties: GraphProperties) -> CGPoint {
        let xPartsCount = abs(graphProperties.xPartition) + 1
        let yPartsCount = abs(graphProperties.yPartition) + 1
        
        let x = graphProperties.graphCenterX + graphProperties.cellWidth * CGFloat(index * xPartsCount)
        let y = graphProperties.graphCenterY - graphProperties.cellHeight * CGFloat(number * Float(yPartsCount))
        
        return CGPoint(x: x, y: y)
    }
    
    private static func digitsCount(value: Int) -> Int {
        return String(value).compactMap{$0.wholeNumberValue}.count
    }
}
