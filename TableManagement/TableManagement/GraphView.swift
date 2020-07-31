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
    
    // Not from here
    static let xLen = -4
    static let yLen = -10
}

private struct GraphProperties {
    var xCount: Int
    var yCount: Int
    
    var xLen: Int
    var yLen: Int
    
    var yMax: Int
    var yMin: Int
    
    var graphCenter: CGPoint

    var cellSize: CGSize
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
    
    var gridColor: UIColor
    var graphColor: UIColor
    var positiveColor: UIColor
    var negativeColor: UIColor
    
    init() {
        //super.init(frame: .zero)
        
        padding = GraphViewDefaultSettings.padding
        fontPadding = GraphViewDefaultSettings.fontPadding

        lineWidth = GraphViewDefaultSettings.lineWidth
        pointSize = GraphViewDefaultSettings.pointSize
        dashSize = GraphViewDefaultSettings.dashSize
        graphCenterSize = GraphViewDefaultSettings.graphCenterSize
        fontSize = GraphViewDefaultSettings.fontSize

        gridColor = GraphViewDefaultSettings.gridColor
        graphColor = GraphViewDefaultSettings.graphColor
        positiveColor = GraphViewDefaultSettings.positiveColor
        negativeColor = GraphViewDefaultSettings.negativeColor

        //xLen = GraphViewDefaultSettings.xLen
        //yLen = GraphViewDefaultSettings.yLen

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
                
                let yAxisTextPadding = CGFloat(max(GraphView.digitsCount(value: Int(numberMax)), GraphView.digitsCount(value: Int(numberMin))) + 1) * fontPadding
                let gridRect = CGRect(x: padding + yAxisTextPadding, y: padding + fontPadding, width: rect.width - 2 * padding - yAxisTextPadding, height: rect.height - 2 * padding - fontPadding)
                let graphProperties = GraphView.calculateGraphProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, numbersCount: numbersCount)
                
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
    
    private func drawGrid(_ context: CGContext, gridRect: CGRect, graphProperties: GraphProperties) {
        let graphCenter = graphProperties.graphCenter
        let cellSize = graphProperties.cellSize
    
        // X Axis
        if graphProperties.xLen < 0 {
            let absXLen = abs(graphProperties.xLen)
            
            // Increasing the grid step
            for i in 0..<graphProperties.xCount {
                if i % absXLen == 0 {
                    let stepIndex = i * absXLen
                    let xPosition = gridRect.minX + cellSize.width * CGFloat(i * absXLen)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphCenter.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphCenter.y - dashSize / 2)
                    
                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if stepIndex != 0 {
                        drawString(string: String(stepIndex), point: CGPoint(x: xPosition, y: graphCenter.y + fontPadding))
                    }
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.xCount {
                for j in 0..<graphProperties.xLen {
                    let stepIndex = i * graphProperties.xLen + j
                    let xPosition = gridRect.minX + cellSize.width * CGFloat(stepIndex)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphCenter.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphCenter.y - dashSize / 2)

                    drawLine(context, begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(context, begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                    
                    if stepIndex != 0 {
                        drawString(string: String(stepIndex), point: CGPoint(x: xPosition, y: graphCenter.y + fontPadding))
                    }
                }
            }
        }
        
        let yMin = graphProperties.yMin
        let yAxisTextPadding = CGFloat(max(GraphView.digitsCount(value: graphProperties.yCount - yMin), GraphView.digitsCount(value: yMin))) * fontPadding
        
        // Y Axis
        if graphProperties.yLen < 0 {
            let absYLen = abs(graphProperties.yLen)

            // Increasing the grid step
            for i in 0..<graphProperties.yCount {
                if i % absYLen == 0 {
                    let yPosition = gridRect.maxY - cellSize.height * CGFloat(i * absYLen)
                    let horizontalDashBegin = CGPoint(x: graphCenter.x + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: graphCenter.x - dashSize / 2, y: yPosition)
                    
                    drawLine(context, begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(context, begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                    
                    drawString(string: String(i + yMin), point: CGPoint(x: graphCenter.x - yAxisTextPadding, y: yPosition))
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.yCount {
                for j in 0..<graphProperties.yLen {
                    let yPosition = gridRect.maxY - cellSize.height * CGFloat(i * graphProperties.yLen + j)
                    let horizontalDashBegin = CGPoint(x: graphCenter.x + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: graphCenter.x - dashSize / 2, y: yPosition)
                    
                    drawLine(context, begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(context, begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                    
                    drawString(string: String(i + yMin), point: CGPoint(x: graphCenter.x - yAxisTextPadding, y: yPosition))
                }
            }
        }
        
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.maxX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.minY), color: gridColor)
        drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.maxY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        
        if 0 < graphProperties.xCount {
            drawPoint(context, point: graphCenter, size: graphCenterSize, color: graphColor)
            drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: graphColor)
            drawLine(context, begin: graphCenter, end: CGPoint(x: gridRect.maxX, y: graphCenter.y), color: graphColor)
            
            if graphCenter.y != gridRect.minY {
                drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX + dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
                drawLine(context, begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX - dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
                
                drawString(string: "Y", point: CGPoint(x: gridRect.minX, y: gridRect.minY - fontPadding))
            }
            
            drawLine(context, begin: CGPoint(x: gridRect.maxX, y: graphCenter.y), end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y - dashSize), color: graphColor)
            drawLine(context, begin: CGPoint(x: gridRect.maxX, y: graphCenter.y), end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y + dashSize), color: graphColor)
            
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
        let atributedString = NSAttributedString(string: string, attributes: attribute)
        
        atributedString.draw(at: CGPoint(x: point.x - fontSize / 2, y: point.y - fontSize / 2))
    }
    
    private static func calculateGraphProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, numbersCount: Int) -> GraphProperties {
        let xLen = GraphViewDefaultSettings.xLen
        let yLen = GraphViewDefaultSettings.yLen
        
        var graphProperties = GraphProperties(xCount: 0, yCount: 0, xLen: 0, yLen: 0, yMax: 0, yMin: 0, graphCenter: CGPoint(), cellSize: CGSize())
        
        if 0 < numbersCount {
            // Calculating the X axis width of the grid
            var xMax = numbersCount

            if xLen < -1 {
                xMax += abs(xLen) - xMax % abs(xLen)
            }

            let xCount = xMax
            let xWidth = CGFloat(xCount * abs(xLen))

            // Calculating the Y axis width of the grid
            var yMax = numberMax == Float(Int(numberMax)) ? Int(numberMax) + 1 : Int(ceilf(numberMax))
            var yMin = 0
    
            if numberMin < 0 {
                yMin = numberMin == Float(Int(numberMin)) ? Int(numberMin) - 1 : Int(floorf(numberMin))
            }

            if yLen < -1 {
                if 0 < yMax {
                    yMax += abs(yLen) - yMax % abs(yLen)
                }

                if yMin < 0 {
                    yMin += yLen - yMin % yLen
                }
            }

            let yCount = yMax - yMin
            let yHeight = CGFloat(yCount * abs(yLen))

            let cellSize = CGSize(width: gridRect.width / xWidth, height: gridRect.height / yHeight)
            let graphCenter = CGPoint(x: gridRect.minX, y: gridRect.minY + cellSize.height * CGFloat(yMax * abs(yLen)))
            
            graphProperties = GraphProperties(xCount: xCount, yCount: yCount, xLen: xLen, yLen: yLen, yMax: yMax, yMin: yMin,graphCenter: graphCenter, cellSize: cellSize)
        }
        
        return graphProperties
    }
    
    private static func getGraphPoint(index: Int, number: Float, graphProperties: GraphProperties) -> CGPoint {
        let graphCenter = graphProperties.graphCenter
        let cellSize = graphProperties.cellSize
        
        let x = graphCenter.x + cellSize.width * CGFloat(index * abs(graphProperties.xLen))
        let y = graphCenter.y - cellSize.height * CGFloat(number * Float(abs(graphProperties.yLen)))
        
        return CGPoint(x: x, y: y)
    }
    
    private static func digitsCount(value: Int) -> Int {
        return String(value).compactMap{$0.wholeNumberValue}.count
    }
}
