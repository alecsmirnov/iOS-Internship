//
//  GraphView.swift
//  TableManagement
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum GraphViewDefaultSettings {
    static let padding: CGFloat = 20
    
    static let lineWidth:       CGFloat = 1
    static let pointSize:       CGFloat = 2
    static let dashSize:        CGFloat = 3
    static let graphCenterSize: CGFloat = 4
    
    static let gridColor       = UIColor.lightGray
    static let graphColor      = UIColor.black
    static let backgroundColor = UIColor.white
    
    // Not from here
    static let xLen = -3
    static let yLen = -4
}

private struct GraphProperties {
    var xCount: Int
    var yCount: Int
    
    var xLen: Int
    var yLen: Int
    
    var graphCenter: CGPoint
    
    var cellSize: CGSize
}

class GraphView: UIView {
    var dataSource: GraphViewDataSource!
    
    var padding: CGFloat
    
    var lineWidth: CGFloat
    var pointSize: CGFloat
    var dashSize: CGFloat
    var graphCenterSize: CGFloat
    
    var gridColor: UIColor
    var graphColor: UIColor
    
    init() {
        // super.init(frame: .zero)

        padding = GraphViewDefaultSettings.padding

        lineWidth = GraphViewDefaultSettings.lineWidth
        pointSize = GraphViewDefaultSettings.pointSize
        dashSize = GraphViewDefaultSettings.dashSize
        graphCenterSize = GraphViewDefaultSettings.graphCenterSize

        gridColor = GraphViewDefaultSettings.gridColor
        graphColor = GraphViewDefaultSettings.graphColor

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
                
                let gridRect = CGRect(x: padding, y: padding, width: rect.width - 2 * padding, height: rect.height - 2 * padding)
                let graphProperties = GraphView.calculateGraphProperties(gridRect: gridRect, numberMax: numberMax, numberMin: numberMin, numbersCount: numbersCount)
                
                drawGrid(gridRect: gridRect, graphProperties: graphProperties)
                drawNumbers(graphProperties: graphProperties)
            }
        }
    }
    
    private func drawGrid(gridRect: CGRect, graphProperties: GraphProperties) {
        let graphCenter = graphProperties.graphCenter
        let cellSize = graphProperties.cellSize
        
        // X Axis
        if graphProperties.xLen < 0 {
            let absXLen = abs(graphProperties.xLen)
            
            // Increasing the grid step
            for i in 0..<graphProperties.xCount {
                if i % absXLen == 0 {
                    let xPosition = gridRect.minX + cellSize.width * CGFloat(i * absXLen)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphCenter.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphCenter.y - dashSize / 2)
                    
                    drawLine(begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<graphProperties.xCount {
                for j in 0..<graphProperties.xLen {
                    let xPosition = gridRect.minX + cellSize.width * CGFloat(i * graphProperties.xLen + j)
                    let verticalDashBegin = CGPoint(x: xPosition, y: graphCenter.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: graphCenter.y - dashSize / 2)

                    drawLine(begin: CGPoint(x: xPosition, y: gridRect.minY), end: CGPoint(x: xPosition, y: gridRect.maxY), color: gridColor)
                    drawLine(begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                }
            }
        }
        
        // Y Axis
        if graphProperties.yLen < 0 {
            let absYLen = abs(graphProperties.yLen)
            
            // Increasing the grid step
            for i in 0..<graphProperties.yCount {
                if i % absYLen == 0 {
                    let yPosition = gridRect.maxY - cellSize.height * CGFloat(i * absYLen)
                    let horizontalDashBegin = CGPoint(x: graphCenter.x + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: graphCenter.x - dashSize / 2, y: yPosition)
                    
                    drawLine(begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
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
                    
                    drawLine(begin: CGPoint(x: gridRect.minX, y: yPosition), end: CGPoint(x: gridRect.maxX, y: yPosition), color: gridColor)
                    drawLine(begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                }
            }
        }
        
        drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: gridColor)
        drawLine(begin: CGPoint(x: gridRect.maxX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.maxX, y: gridRect.minY), color: gridColor)
        drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.maxY), end: CGPoint(x: gridRect.maxX, y: gridRect.maxY), color: gridColor)
        
        if 0 < graphProperties.xCount {
            drawPoint(point: graphCenter, size: graphCenterSize, color: graphColor)
            drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX, y: gridRect.maxY), color: graphColor)
            drawLine(begin: graphCenter, end: CGPoint(x: gridRect.maxX, y: graphCenter.y), color: graphColor)
            
            if graphCenter.y != gridRect.minY {
                drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX + dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
                drawLine(begin: CGPoint(x: gridRect.minX, y: gridRect.minY), end: CGPoint(x: gridRect.minX - dashSize, y: gridRect.minY + 2 * dashSize), color: graphColor)
            }
            
            drawLine(begin: CGPoint(x: gridRect.maxX, y: graphCenter.y), end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y - dashSize), color: graphColor)
            drawLine(begin: CGPoint(x: gridRect.maxX, y: graphCenter.y), end: CGPoint(x: gridRect.maxX - 2 * dashSize, y: graphCenter.y + dashSize), color: graphColor)
        }
    }
    
    private func drawNumbers(graphProperties: GraphProperties) {
        if let dataSource = dataSource {
            let numbersCount = dataSource.graphViewDataSourceCount(self)
        
            for i in 0..<numbersCount {
                let number = dataSource.graphViewDataSourceNumber(self, at: i)
                let point = GraphView.getGraphPoint(index: i, number: number, graphProperties: graphProperties)
                let color = number < 0 ? UIColor.blue : UIColor.red

                drawPoint(point: point, size: pointSize, color: color)
            }
        }
    }
    
    private func drawLine(begin: CGPoint, end: CGPoint, color: UIColor) {
        let linePath = UIBezierPath()
        
        linePath.lineWidth = lineWidth
        
        linePath.move(to: begin)
        linePath.addLine(to: end)
        
        color.setStroke()
        linePath.stroke()
    }
    
    private func drawPoint(point: CGPoint, size: CGFloat, color: UIColor) {
        let pointRect = CGRect(x: point.x - size / 2, y: point.y - size / 2, width: size, height: size)
        let pointPath = UIBezierPath(ovalIn: pointRect)

        color.setFill()
        pointPath.fill()
    }
    
    private static func calculateGraphProperties(gridRect: CGRect, numberMax: Float, numberMin: Float, numbersCount: Int) -> GraphProperties {
        let xLen = GraphViewDefaultSettings.xLen
        let yLen = GraphViewDefaultSettings.yLen
        
        var graphProperties = GraphProperties(xCount: 0, yCount: 0, xLen: 0, yLen: 0, graphCenter: CGPoint(), cellSize: CGSize())
        
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
            
            graphProperties = GraphProperties(xCount: xCount, yCount: yCount, xLen: xLen, yLen: yLen, graphCenter: graphCenter, cellSize: cellSize)
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
}
