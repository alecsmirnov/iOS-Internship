//
//  GraphView.swift
//  TestProject
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum Sizes {
    static let lineWidth: CGFloat = 1
    
    static let stepMin: CGFloat = 15
    static let stepMax: CGFloat = 30
}

private struct GridInfo {
    var cellSize: CGSize
    
    var xCount: Int
    var yMax: Int
    var yMin: Int
    
    var xLen: Int
    var yLen: Int
    
    var center: CGPoint
}

@IBDesignable
class GraphView: UIView {
    
    //var numbers = DataSource(size: 100, rangeMin: -23, rangeMax: 30).arrayData()
    var numbers: [Float] = [-1, 0, 5, 9, 13, -4, -3.2, 6.7, 9.532, -2, -3, -5, 1, 2, 20, 23, 23, 12, 2, 5, 6, -5, 5, -11]
    //var numbers: [Float] = [-1, -5, -9, -4, -3.2, -6.7, -9.532, -2, -3, -5, -1, -2, -20, -23, -23, -12, -2, -5, -6, -5, -5, -11]
    
    override func draw(_ rect: CGRect) {
        let padding: CGFloat = 10
        
        let fieldRect = CGRect(x: padding, y: padding, width: rect.width - 2 * padding, height: rect.height - 2 * padding)
        
        let gridInfo = getGridInfo(fieldRect)
        
        drawGrid(fieldRect, gridInfo: gridInfo)
        drawNumbers(fieldRect, gridInfo: gridInfo)
    }
    
    private func drawGrid(_ rect: CGRect, gridInfo: GridInfo) {
        let drawLine: (CGPoint, CGPoint, UIColor) -> () = { (a: CGPoint, b: CGPoint, color: UIColor) -> () in
            let linePath = UIBezierPath()
            
            linePath.move(to: a)
            linePath.addLine(to: b)
            
            color.setStroke()
            linePath.stroke()
        }

        let dashSize: CGFloat = 3
        let graphColor: UIColor = UIColor.black
        let gridColor: UIColor = UIColor.lightGray
        
        // X Axis
        if gridInfo.xLen < 0 {
            // Increasing the grid step
            for i in 0..<gridInfo.xCount {
                if i % abs(gridInfo.xLen) == 0 {
                    let xPosition = rect.minX + gridInfo.cellSize.width * CGFloat(i * abs(gridInfo.xLen))
                    let verticalDashBegin = CGPoint(x: xPosition, y: gridInfo.center.y + dashSize / 2)
                    let verticalDashEnd = CGPoint(x: xPosition, y: gridInfo.center.y - dashSize / 2)
                    
                    drawLine(CGPoint(x: xPosition, y: rect.minY), CGPoint(x: xPosition, y: rect.maxY), gridColor)
                    drawLine(verticalDashBegin, verticalDashEnd, graphColor)
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

                    drawLine(CGPoint(x: xPosition, y: rect.minY), CGPoint(x: xPosition, y: rect.maxY), gridColor)
                    drawLine(verticalDashBegin, verticalDashEnd, graphColor)
                }
            }
        }
        
        // Y Axis
        // Increasing the grid step
        for i in 1..<(gridInfo.yMax - gridInfo.yMin) {
            for j in 0..<gridInfo.yLen {
                let yPosition = rect.minY + gridInfo.cellSize.height * CGFloat(i * gridInfo.yLen + j)
                let horizontalDashBegin = CGPoint(x: gridInfo.center.x + dashSize / 2, y: yPosition)
                let horizontalDashEnd = CGPoint(x: gridInfo.center.x - dashSize / 2, y: yPosition)
                
                drawLine(CGPoint(x: rect.minX, y: yPosition), CGPoint(x: rect.maxX, y: yPosition), gridColor)
                drawLine(horizontalDashBegin, horizontalDashEnd, graphColor)
            }
        }
        
        let xPosition = gridInfo.center.x + rect.width
        drawLine(CGPoint(x: xPosition, y: rect.minY), CGPoint(x: xPosition, y: rect.maxY), gridColor)
        drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY), gridColor)
        drawLine(CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.maxX, y: rect.maxY), gridColor)
        
        drawLine(gridInfo.center, CGPoint(x: rect.maxX, y: gridInfo.center.y), graphColor)
        
        drawLine(CGPoint(x: xPosition, y: gridInfo.center.y), CGPoint(x: xPosition - 2 * dashSize, y: gridInfo.center.y - dashSize), graphColor)
        drawLine(CGPoint(x: xPosition, y: gridInfo.center.y), CGPoint(x: xPosition - 2 * dashSize, y: gridInfo.center.y + dashSize), graphColor)
        
        drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX, y: rect.maxY), graphColor)
        
        if 0 < gridInfo.yMax {
            drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX + dashSize, y: rect.minY + 2 * dashSize), graphColor)
            drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX - dashSize, y: rect.minY + 2 * dashSize), graphColor)
        }
    }
    
    private func drawNumbers(_ rect: CGRect, gridInfo: GridInfo) {
        let drawPoint: (CGPoint, CGFloat, UIColor) -> () = { (point: CGPoint, size: CGFloat, color: UIColor) -> () in
            let pointRect = CGRect(x: point.x - size / 2, y: point.y - size / 2, width: size, height: size)
            let pointPath = UIBezierPath(ovalIn: pointRect)

            color.setFill()
            pointPath.fill()
        }
        
        let pointSize: CGFloat = 2
        
        for i in 0..<numbers.count {
            let number = numbers[i]
            let point = getNumberPoint(index: i, number: number, gridInfo: gridInfo)
            let pointColor = number < 0 ? UIColor.blue : UIColor.red
            
            drawPoint(point, pointSize, pointColor)
        }
    }
    
    private func getNumberPoint(index: Int, number: Float, gridInfo: GridInfo) -> CGPoint {
        let x = gridInfo.center.x + gridInfo.cellSize.width * CGFloat(index * abs(gridInfo.xLen))
        let y = gridInfo.center.y - gridInfo.cellSize.height * CGFloat(number * Float(abs(gridInfo.yLen)))
        
        return CGPoint(x: x, y: y)
    }
    
    private func getGridInfo(_ rect: CGRect) -> GridInfo {
        let xLen = 2
        let yLen = 1
        
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
        
        // Calculating the X axis width of the grid
        var xCount = numbers.count
        var xWidth = CGFloat(xCount)
        
        if xLen < -1 {
            xCount += 1
            xWidth += CGFloat(abs(xLen) - Int(xWidth) % abs(xLen))
        }
        
        xWidth *= CGFloat(abs(xLen))
        
        // Calculating the Y axis width of the grid
        var yCount = CGFloat(yMax - yMin)
        var yHeight = CGFloat(yCount)
        
        if yLen < -1 {
            yCount += 1
            yCount += CGFloat(abs(yLen) - Int(yHeight) % abs(yLen))
        }
        
        yHeight *= CGFloat(abs(yLen))
        
        let cellSize = CGSize(width: rect.width / xWidth, height: rect.height / yHeight)
        let center = CGPoint(x: rect.minX, y: rect.minY + cellSize.height * CGFloat(yMax * yLen))

        return GridInfo(cellSize: cellSize, xCount: xCount, yMax: yMax, yMin: yMin, xLen: xLen, yLen: yLen, center: center)
    }
}
