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
    
    static let gridColor       = UIColor.lightGray
    static let graphColor      = UIColor.black
    static let positiveColor   = UIColor.red
    static let negativeColor   = UIColor.blue
    static let backgroundColor = UIColor.white
}

class GraphView: UIView {
    var numbers: [Float] = []
    
    var padding = GraphViewDefaultSettings.padding
    var fontPadding = GraphViewDefaultSettings.fontPadding
    
    var lineWidth = GraphViewDefaultSettings.lineWidth
    var pointSize = GraphViewDefaultSettings.pointSize
    var dashSize = GraphViewDefaultSettings.dashSize
    var graphCenterSize = GraphViewDefaultSettings.graphCenterSize
    var fontSize = GraphViewDefaultSettings.fontSize
    
    var gridColor = GraphViewDefaultSettings.gridColor
    var graphColor = GraphViewDefaultSettings.graphColor
    var positiveColor = GraphViewDefaultSettings.positiveColor
    var negativeColor = GraphViewDefaultSettings.negativeColor
    
    var xStep = 1
    var yStep = 1
    
    var xPercentageStep = false
    var yPercentageStep = false
    
    private var yAxisTextPadding: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = GraphViewDefaultSettings.backgroundColor
    }
    
    override func draw(_ rect: CGRect) {
        drawGraph(rect)
    }
    
    private func drawGraph(_ rect: CGRect) {
        if !numbers.isEmpty {
            var numberMax: Float = 0
            var numberMin: Float = 0
            
            if let max = numbers.max() {
                numberMax = max
            }
            
            if let min = numbers.min() {
                numberMin = min
            }
            
            yAxisTextPadding = CGFloat(max(GraphView.digitsCount(value: Int(numberMax)),
                                           GraphView.digitsCount(value: Int(numberMin))) + 1) * fontPadding

            let gridRect = CGRect(x: padding + yAxisTextPadding,
                                  y: padding + fontPadding,
                                  width: rect.width - 2 * padding - yAxisTextPadding,
                                  height: rect.height - 2 * (padding + fontPadding))
            let graphProperties = GraphProperties.calculateProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin,
                                                                      numbersCount: numbers.count, xStep: xStep, yStep: yStep,
                                                                      xPercentageStep: xPercentageStep, yPercentageStep: yPercentageStep)
            
            if let graphProperties = graphProperties {
                if let context = UIGraphicsGetCurrentContext() {
                    UIGraphicsPushContext(context)
                    
                    context.saveGState()
                    
                    drawGrid(context, gridRect: gridRect, graphProperties: graphProperties)
                    drawNumbers(context, graphProperties: graphProperties)
                    
                    
                    context.restoreGState()
                    
                    UIGraphicsPopContext()
                }
            }
        }
    }
    
    private func drawGrid(_ context: CGContext, gridRect: CGRect, graphProperties: GraphProperties.Properties) {
        // X Axis
        for i in 0..<graphProperties.xCount {
            if i % graphProperties.xPartsCount == 0 {
                let stepIndex = i * graphProperties.xPartsCount
                let xPosition = gridRect.minX + graphProperties.partsWidth * CGFloat(stepIndex)
                let verticalDashBegin = CGPoint(x: xPosition, y: graphProperties.graphCenterY + dashSize / 2)
                let verticalDashEnd = CGPoint(x: xPosition, y: graphProperties.graphCenterY - dashSize / 2)
                
                drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                
                if i != 0 {
                    drawString(string: String(stepIndex / graphProperties.xPartsCount), point: CGPoint(x: xPosition, y: graphProperties.graphCenterY + fontPadding))
                }
            }
        }
        
        // Y Axis
        for i in 0..<graphProperties.yCount {
            if i % graphProperties.yPartsCount == 0 {
                let yPosition = gridRect.maxY - graphProperties.partsHeight * CGFloat(i * graphProperties.yPartsCount)
                let horizontalDashBegin = CGPoint(x: graphProperties.graphCenterX + dashSize / 2, y: yPosition)
                let horizontalDashEnd = CGPoint(x: graphProperties.graphCenterX - dashSize / 2, y: yPosition)
                
                drawLine(context, begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                drawLine(context, begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                
                drawString(string: String(i + graphProperties.yMin), point: CGPoint(x: graphProperties.graphCenterX - yAxisTextPadding, y: yPosition))
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
        let graphPath = UIBezierPath()
        
        if !numbers.isEmpty {
            var point = GraphView.getGraphPoint(index: 0, number: numbers[0], graphProperties: graphProperties)
            graphPath.move(to: point)
            
            for i in 1..<numbers.count {
                point = GraphView.getGraphPoint(index: i, number: numbers[i], graphProperties: graphProperties)
                
                graphPath.addLine(to: point)
            }
            
            graphPath.addLine(to: CGPoint(x: point.x, y: graphProperties.graphCenterY))
            graphPath.stroke()
            
            guard let clippingPath = graphPath.copy() as? UIBezierPath else {
                return
            }
            
            clippingPath.addLine(to: CGPoint(x: graphProperties.graphCenterX, y: graphProperties.graphCenterY))
            clippingPath.close()
            
            clippingPath.addClip()
            
            let positivePartColors = [UIColor(white: 1, alpha: 0).cgColor, positiveColor.cgColor]
            let negativePartColors = [UIColor(white: 1, alpha: 0).cgColor, negativeColor.cgColor]

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations: [CGFloat] = [0.0, 1.0]

            guard let positiveGradient = CGGradient(colorsSpace: colorSpace, colors: positivePartColors as CFArray, locations: colorLocations) else {
                return
            }
            
            guard let negativeGradient = CGGradient(colorsSpace: colorSpace, colors: negativePartColors as CFArray, locations: colorLocations) else {
                return
            }
            
            guard let max = numbers.max() else {
                return
            }
            
            guard let min = numbers.min() else {
                return
            }
            
            let maxY = GraphView.getGraphPoint(index: 0, number: max, graphProperties: graphProperties).y
            let minY = GraphView.getGraphPoint(index: 0, number: min, graphProperties: graphProperties).y
            
            let positiveGradientStartPoint = CGPoint(x: graphProperties.graphCenterX, y: graphProperties.graphCenterY)
            let positiveGradientEndPoint = CGPoint(x: graphProperties.graphCenterX, y: maxY)
            
            let negativeGradientStartPoint = CGPoint(x: graphProperties.graphCenterX, y: graphProperties.graphCenterY)
            let negativeGradientEndPoint = CGPoint(x: graphProperties.graphCenterX, y: minY)
            
            context.drawLinearGradient(positiveGradient, start: positiveGradientStartPoint, end: positiveGradientEndPoint, options: [])
            context.drawLinearGradient(negativeGradient, start: negativeGradientStartPoint, end: negativeGradientEndPoint, options: [])
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
        let x = graphProperties.graphCenterX + graphProperties.partsWidth * CGFloat(index * graphProperties.xPartsCount)
        let y = graphProperties.graphCenterY - graphProperties.partsHeight * CGFloat(number * Float(graphProperties.yPartsCount))
        
        return CGPoint(x: x, y: y)
    }
    
    private static func digitsCount(value: Int) -> Int {
        return String(value).compactMap{$0.wholeNumberValue}.count
    }
}
