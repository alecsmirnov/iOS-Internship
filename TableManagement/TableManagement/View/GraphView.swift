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
    
    static let cellWidth:       CGFloat = 30
    static let cellHeight:      CGFloat = 20
    
    static let captionsPrecision: Int = 2
    
    static let gridColor       = UIColor.lightGray
    static let graphColor      = UIColor.black
    static let positiveColor   = UIColor.red
    static let negativeColor   = UIColor.blue
    static let backgroundColor = UIColor.white
}

class GraphView: UIView {
    var graphViewModel: GraphViewModel!
    
    var padding: CGFloat = GraphViewDefaultSettings.padding
    var fontPadding: CGFloat = GraphViewDefaultSettings.fontPadding
    
    var lineWidth: CGFloat = GraphViewDefaultSettings.lineWidth
    var pointSize: CGFloat = GraphViewDefaultSettings.pointSize
    var dashSize: CGFloat = GraphViewDefaultSettings.dashSize
    var graphCenterSize: CGFloat = GraphViewDefaultSettings.graphCenterSize
    var fontSize: CGFloat = GraphViewDefaultSettings.fontSize
    
    var cellWidth: CGFloat = GraphViewDefaultSettings.cellWidth
    var cellHeight: CGFloat = GraphViewDefaultSettings.cellHeight
    
    var captionsPrecision: Int = GraphViewDefaultSettings.captionsPrecision
    
    var gridColor: UIColor = GraphViewDefaultSettings.gridColor
    var graphColor: UIColor = GraphViewDefaultSettings.graphColor
    var positiveColor: UIColor = GraphViewDefaultSettings.positiveColor
    var negativeColor: UIColor = GraphViewDefaultSettings.negativeColor
    
    private var yAxisTextPadding: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = GraphViewDefaultSettings.backgroundColor
    }
    
    override func draw(_ rect: CGRect) {
        drawGraph(rect)
    }
    
    private func drawGraph(_ rect: CGRect) {
        if let graphViewModel = graphViewModel {
            let numbersCount = graphViewModel.count
            
            if 0 < numbersCount {
                var numberMax: Float = 0
                var numberMin: Float = 0
                
                if let max = graphViewModel.max() {
                    numberMax = max
                }
                
                if let min = graphViewModel.min() {
                    numberMin = min
                }
                
                yAxisTextPadding = CGFloat(max(GraphView.digitsCount(value: Int(numberMax)),
                                               GraphView.digitsCount(value: Int(numberMin))) + captionsPrecision + 1) * fontPadding

                let gridRect = CGRect(x: padding + yAxisTextPadding,
                                      y: padding + fontPadding,
                                      width: rect.width - 2 * padding - yAxisTextPadding,
                                      height: rect.height - 2 * (padding + fontPadding))
                let graphProperties = GraphProperties.calculateProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin,
                                                                         numbersCount: numbersCount, cellWidth: cellWidth, cellHeight: cellHeight)
                
                if let graphProperties = graphProperties {
                    if let context = UIGraphicsGetCurrentContext() {
                        UIGraphicsPushContext(context)
                        
                        drawGrid(context, gridRect: gridRect, graphProperties: graphProperties)
                        drawNumbers(context, graphProperties: graphProperties)
                        
                        UIGraphicsPopContext()
                    }
                }
            }
        }
    }
    
    private func drawGrid(_ context: CGContext, gridRect: CGRect, graphProperties: GraphProperties.Properties) {
        let xPartsCount = abs(graphProperties.xPartition) + 1
        let yPartsCount = abs(graphProperties.yPartition) + 1
        
        // X Axis
        if graphProperties.xPartition < 0 {
            // Increasing the grid step
            for i in 0..<graphProperties.xCount {
                if i % xPartsCount == 0 {
                    let stepIndex = i * xPartsCount
                    let xPosition = gridRect.minX + graphProperties.partsWidth * CGFloat(i * xPartsCount)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphProperties.graphCenterY + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphProperties.graphCenterY - dashSize / 2)
                    
                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if i != 0 {
                        drawString(string: String(stepIndex / xPartsCount), point: CGPoint(x: xPosition, y: graphProperties.graphCenterY + fontPadding))
                    }
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.xCount {
                for j in 0..<xPartsCount {
                    let stepIndex = i * xPartsCount + j
                    let xPosition = gridRect.minX + graphProperties.partsWidth * CGFloat(stepIndex)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphProperties.graphCenterY + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphProperties.graphCenterY - dashSize / 2)

                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if i != 0 {
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
                    let yPosition = gridRect.maxY - graphProperties.partsHeight * CGFloat(i * yPartsCount)
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
                    let yPosition = gridRect.maxY - graphProperties.partsHeight * CGFloat(stepIndex)
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
    
    private func drawNumbers(_ context: CGContext, graphProperties: GraphProperties.Properties) {
        if let graphViewModel = graphViewModel {
            let numbersCount = graphViewModel.count
        
            var positivePoints: [CGPoint] = []
            var negativePoints: [CGPoint] = []
            
            for i in 0..<numbersCount {
                let number = graphViewModel.number(at: i)
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

    private static func getGraphPoint(index: Int, number: Float, graphProperties: GraphProperties.Properties) -> CGPoint {
        let xPartsCount = abs(graphProperties.xPartition) + 1
        let yPartsCount = abs(graphProperties.yPartition) + 1
        
        let x = graphProperties.graphCenterX + graphProperties.partsWidth * CGFloat(index * xPartsCount)
        let y = graphProperties.graphCenterY - graphProperties.partsHeight * CGFloat(number * Float(yPartsCount))
        
        return CGPoint(x: x, y: y)
    }
    
    private static func digitsCount(value: Int) -> Int {
        return String(value).compactMap{$0.wholeNumberValue}.count
    }
}
