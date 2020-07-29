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
    
    var xStep: CGFloat
    var yStep: CGFloat
    
    var center: CGPoint
}

@IBDesignable
class GraphView: UIView {
    
    //var numbers = DataSource(size: 53, rangeMin: -23, rangeMax: 30).arrayData()
    var numbers: [Float] = [-1, 0, 5, 9, -4, -3.2, 6.7, 9.532, -2, -3, -5, 1, 2, 20, 23, 23, 12, 2, 5, 6, -5, 5, -11]
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
        
        let xStep = gridInfo.xStep
        let yStep = gridInfo.yStep
        
        let xPosition = gridInfo.center.x + rect.width
        //let xPosition = gridInfo.center.x + gridInfo.cellSize.width * CGFloat(gridInfo.xCount)
        drawLine(CGPoint(x: xPosition, y: rect.minY), CGPoint(x: xPosition, y: rect.maxY), gridColor)
        drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY), gridColor)
        drawLine(CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.maxX, y: rect.maxY), gridColor)
        
        // X Axis
        drawLine(gridInfo.center, CGPoint(x: rect.maxX, y: gridInfo.center.y), graphColor)
        
        for i in stride(from: xStep, to: CGFloat(gridInfo.xCount), by: xStep) {
            let xPosition = gridInfo.center.x + gridInfo.cellSize.width * i
            let aPoint = CGPoint(x: xPosition, y: gridInfo.center.y + dashSize / 2)
            let bPoint = CGPoint(x: xPosition, y: gridInfo.center.y - dashSize / 2)
            
            drawLine(CGPoint(x: xPosition, y: rect.minY), CGPoint(x: xPosition, y: rect.maxY), gridColor)
            drawLine(aPoint, bPoint, graphColor)
        }
        
        drawLine(CGPoint(x: xPosition, y: gridInfo.center.y), CGPoint(x: xPosition - 2 * dashSize, y: gridInfo.center.y - dashSize), graphColor)
        drawLine(CGPoint(x: xPosition, y: gridInfo.center.y), CGPoint(x: xPosition - 2 * dashSize, y: gridInfo.center.y + dashSize), graphColor)
        
        // Y Axis
        drawLine(CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX, y: rect.maxY), graphColor)
        
        for i in stride(from: yStep, to: CGFloat(gridInfo.yMax), by: yStep) {
            let yPosition = gridInfo.center.y - gridInfo.cellSize.height * i
            let aPoint = CGPoint(x: gridInfo.center.x + dashSize / 2, y: yPosition)
            let bPoint = CGPoint(x: gridInfo.center.x - dashSize / 2, y: yPosition)
            
            drawLine(CGPoint(x: rect.minX, y: yPosition), CGPoint(x: rect.maxX, y: yPosition), gridColor)
            drawLine(aPoint, bPoint, graphColor)
        }
        
        for i in stride(from: -yStep, to: CGFloat(gridInfo.yMin), by: -yStep) {
            let yPosition = gridInfo.center.y - gridInfo.cellSize.height * i
            let aPoint = CGPoint(x: gridInfo.center.x + dashSize / 2, y: yPosition)
            let bPoint = CGPoint(x: gridInfo.center.x - dashSize / 2, y: yPosition)
            
            drawLine(CGPoint(x: rect.minX, y: yPosition), CGPoint(x: rect.maxX, y: yPosition), gridColor)
            drawLine(aPoint, bPoint, graphColor)
        }
        
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
        let x = gridInfo.center.x + gridInfo.cellSize.width * CGFloat(index)
        let y = gridInfo.center.y - gridInfo.cellSize.height * CGFloat(number)
        
        return CGPoint(x: x, y: y)
    }
    
    private func getGridInfo(_ rect: CGRect) -> GridInfo {
        let xStep: CGFloat = 0.1 //0.2721235
        let yStep: CGFloat = 0.88
        
        var yMax = 0
        var yMin = 0
        
        if let max = numbers.max() {
            let yMaxCount = max == Float(Int(max)) ? Int(max) + 1 : Int(ceilf(max))
            yMax = Int(CGFloat(yMaxCount) + yStep - CGFloat(yMaxCount).remainder(dividingBy: yStep))
        }
        
        if let min = numbers.min() {
            if min < 0 {
                let yMinCount = min == Float(Int(min)) ? Int(min) - 1 : Int(floorf(min))
                yMin = Int(CGFloat(yMinCount) - yStep + CGFloat(yMinCount).remainder(dividingBy: yStep))
            }
        }
        
        let xWidth = (CGFloat(numbers.count) + xStep - CGFloat(numbers.count).remainder(dividingBy: xStep))
        
        let xCount = Int(xWidth)
        let yCount = yMax - yMin
        
        let cellSize = CGSize(width: rect.width / xWidth, height: rect.height / CGFloat(yCount))
        let center = CGPoint(x: rect.minX, y: rect.minY + cellSize.height * CGFloat(yMax))

        return GridInfo(cellSize: cellSize, xCount: xCount, yMax: yMax, yMin: yMin, xStep: xStep, yStep: yStep, center: center)
    }
}
