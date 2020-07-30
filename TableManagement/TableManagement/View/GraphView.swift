//
//  GraphView.swift
//  TestProject
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum GridSettings {
    static let padding: CGFloat = 20
    
    static let lineWidth:  CGFloat = 1
    static let pointSize:  CGFloat = 2
    static let dashSize:   CGFloat = 3
    static let centerSize: CGFloat = 4
    
    static let graphColor = UIColor.black
    static let gridColor  = UIColor.lightGray
    
    // Not from here
    static let xLen = -3
    static let yLen = -4
}

private struct GridInfo {
    var cellSize: CGSize
    
    var xCount: Int
    var yCount: Int
    
    var xLen: Int
    var yLen: Int
    
    var center: CGPoint
}

@IBDesignable
class GraphView: UIView {
    
    //var numbers: [Float] = []
    var numbers = DataSource(size: 100, rangeMin: -23, rangeMax: 30).arrayData()

    //var numbers: [Float] = [-1, 0, 5, 9, 13, -4, -3.2, 6.7, 9.532, -2, -3, -5, 1, 2, 20, 23, 23, 12, 2, 5, 6, -5, 5, -11, 7, 6, -30, 18, 27, 40]
    // Positive
    //var numbers: [Float] = [1, 5, 9, 4, 3.2, 6.7, 9.532, 2, 3, 5, 1, 2, 20, 23, 23, 12, 2, 5, 6, 5, 5, 11, 49]
    // Negative
    //var numbers: [Float] = [-1, -5, -9, -4, -3.2, -6.7, -9.532, -2, -3, -5, -1, -2, -20, -23, -23, -12, -2, -5, -6, -5, -5, -11]
    
    override func draw(_ rect: CGRect) {
        let padding = GridSettings.padding
        let fieldRect = CGRect(x: padding, y: padding, width: rect.width - 2 * padding, height: rect.height - 2 * padding)
        
        let gridInfo = getGridInfo(fieldRect)
        
        drawGrid(fieldRect, gridInfo: gridInfo)
        drawNumbers(fieldRect, gridInfo: gridInfo)
    }
    
    private func drawGrid(_ rect: CGRect, gridInfo: GridInfo) {
        let dashSize = GridSettings.dashSize
        let graphColor = GridSettings.graphColor
        let gridColor = GridSettings.gridColor
        
        // X Axis
        if gridInfo.xLen < 0 {
            // Increasing the grid step
            for i in 0..<gridInfo.xCount {
                if i % abs(gridInfo.xLen) == 0 {
                    let xPosition = rect.minX + gridInfo.cellSize.width * CGFloat(i * abs(gridInfo.xLen))
                    let verticalDashBegin = CGPoint(x: xPosition, y: gridInfo.center.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: gridInfo.center.y - dashSize / 2)
                    
                    drawLine(begin: CGPoint(x: xPosition, y: rect.minY), end: CGPoint(x: xPosition, y: rect.maxY), color: gridColor)
                    drawLine(begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<gridInfo.xCount {
                for j in 0..<gridInfo.xLen {
                    let xPosition = rect.minX + gridInfo.cellSize.width * CGFloat(i * gridInfo.xLen + j)
                    let verticalDashBegin = CGPoint(x: xPosition, y: gridInfo.center.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: gridInfo.center.y - dashSize / 2)

                    drawLine(begin: CGPoint(x: xPosition, y: rect.minY), end: CGPoint(x: xPosition, y: rect.maxY), color: gridColor)
                    drawLine(begin: verticalDashBegin, end: verticalDashEnd, color: graphColor)
                }
            }
        }
        
        // Y Axis
        if gridInfo.yLen < 0 {
            // Increasing the grid step
            for i in 0..<gridInfo.yCount {
                if i % abs(gridInfo.yLen) == 0 {
                    let yPosition = rect.maxY - gridInfo.cellSize.height * CGFloat(i * abs(gridInfo.yLen))
                    let horizontalDashBegin = CGPoint(x: gridInfo.center.x + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: gridInfo.center.x - dashSize / 2, y: yPosition)
                    
                    drawLine(begin: CGPoint(x: rect.minX, y: yPosition), end: CGPoint(x: rect.maxX, y: yPosition), color: gridColor)
                    drawLine(begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                }
            }
        }
        else {
            // Decreasing the grid step
            for i in 0..<gridInfo.yCount {
                for j in 0..<gridInfo.yLen {
                    let yPosition = rect.maxY - gridInfo.cellSize.height * CGFloat(i * gridInfo.yLen + j)
                    let horizontalDashBegin = CGPoint(x: gridInfo.center.x + dashSize / 2, y: yPosition)
                    let horizontalDashEnd = CGPoint(x: gridInfo.center.x - dashSize / 2, y: yPosition)
                    
                    drawLine(begin: CGPoint(x: rect.minX, y: yPosition), end: CGPoint(x: rect.maxX, y: yPosition), color: gridColor)
                    drawLine(begin: horizontalDashBegin, end: horizontalDashEnd, color: graphColor)
                }
            }
        }
        
        drawLine(begin: CGPoint(x: rect.minX, y: rect.minY), end: CGPoint(x: rect.minX, y: rect.maxY), color: gridColor)
        drawLine(begin: CGPoint(x: rect.maxX, y: rect.minY), end: CGPoint(x: rect.maxX, y: rect.maxY), color: gridColor)
        drawLine(begin: CGPoint(x: rect.minX, y: rect.minY), end: CGPoint(x: rect.maxX, y: rect.minY), color: gridColor)
        drawLine(begin: CGPoint(x: rect.minX, y: rect.maxY), end: CGPoint(x: rect.maxX, y: rect.maxY), color: gridColor)
        
        if 0 < gridInfo.xCount {
            let centerSize = GridSettings.centerSize
            
            drawPoint(point: gridInfo.center, size: centerSize, color: graphColor)
            drawLine(begin: CGPoint(x: rect.minX, y: rect.minY), end: CGPoint(x: rect.minX, y: rect.maxY), color: graphColor)
            drawLine(begin: gridInfo.center, end: CGPoint(x: rect.maxX, y: gridInfo.center.y), color: graphColor)
            
            if gridInfo.center.y != rect.minY {
                drawLine(begin: CGPoint(x: rect.minX, y: rect.minY), end: CGPoint(x: rect.minX + dashSize, y: rect.minY + 2 * dashSize), color: graphColor)
                drawLine(begin: CGPoint(x: rect.minX, y: rect.minY), end: CGPoint(x: rect.minX - dashSize, y: rect.minY + 2 * dashSize), color: graphColor)
            }
            
            drawLine(begin: CGPoint(x: rect.maxX, y: gridInfo.center.y), end: CGPoint(x: rect.maxX - 2 * dashSize, y: gridInfo.center.y - dashSize), color: graphColor)
            drawLine(begin: CGPoint(x: rect.maxX, y: gridInfo.center.y), end: CGPoint(x: rect.maxX - 2 * dashSize, y: gridInfo.center.y + dashSize), color: graphColor)
        }
    }
    
    private func drawNumbers(_ rect: CGRect, gridInfo: GridInfo) {
        let pointSize = GridSettings.pointSize
        
        for i in 0..<numbers.count {
            let number = numbers[i]
            let point = getNumberPoint(index: i, number: number, gridInfo: gridInfo)
            let color = number < 0 ? UIColor.blue : UIColor.red
            
            drawPoint(point: point, size: pointSize, color: color)
        }
    }
    
    private func getNumberPoint(index: Int, number: Float, gridInfo: GridInfo) -> CGPoint {
        let x = gridInfo.center.x + gridInfo.cellSize.width * CGFloat(index * abs(gridInfo.xLen))
        let y = gridInfo.center.y - gridInfo.cellSize.height * CGFloat(number * Float(abs(gridInfo.yLen)))
        
        return CGPoint(x: x, y: y)
    }
    
    private func drawLine(begin: CGPoint, end: CGPoint, color: UIColor) {
        let linePath = UIBezierPath()
        
        linePath.lineWidth = GridSettings.lineWidth
        
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
    
    
    private func getGridInfo(_ rect: CGRect) -> GridInfo {
        let xLen = GridSettings.xLen
        let yLen = GridSettings.yLen
        
        var gridInfo = GridInfo(cellSize: .zero, xCount: .zero, yCount: .zero, xLen: .zero, yLen: .zero, center: .zero)
        
        if !numbers.isEmpty {
            // Calculating the X axis width of the grid
            var xMax = numbers.count
            
            if xLen < -1 {
                xMax += abs(xLen) - xMax % abs(xLen)
            }
            
            let xCount = xMax
            let xWidth = CGFloat(xCount * abs(xLen))
            
            // Calculating the Y axis width of the grid
            var yMax = 0
            var yMin = 0
            
            if let max = numbers.max() {
                yMax = max == Float(Int(max)) ? Int(max) + 1 : Int(ceilf(max))
            }
            
            if let min = numbers.min() {
                if min < 0 {
                    yMin = min == Float(Int(min)) ? Int(min) - 1 : Int(floorf(min))
                }
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
            
            let cellSize = CGSize(width: rect.width / xWidth, height: rect.height / yHeight)
            let center = CGPoint(x: rect.minX, y: rect.minY + cellSize.height * CGFloat(yMax * abs(yLen)))
            
            gridInfo = GridInfo(cellSize: cellSize, xCount: xCount, yCount: yCount, xLen: xLen, yLen: yLen, center: center)
        }

        return gridInfo
    }
}
