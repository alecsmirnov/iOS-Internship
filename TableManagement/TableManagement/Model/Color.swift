//
//  Color.swift
//  TableManagement
//
//  Created by Admin on 23.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct RGB {
    var red: Float
    var green: Float
    var blue: Float
    
    func toHSV() -> HSV {
        let colorMax = max(red, green, blue)
        let colorMin = min(red, green, blue)
        let delta = colorMax - colorMin
        
        var hue: Float = 0
        
        if delta != 0 {
            switch colorMax {
            case red:
                hue = ((green - blue) / delta).remainder(dividingBy: 6)
                break
            case green:
                hue = (blue - red) / delta + 2
                break
            default:
                hue = (red - green) / delta + 4
                break
            }
        }
        
        hue = (hue < 0 ? hue + 6 : hue) / 6
        
        let saturation = colorMax == 0 ? 0 : delta / colorMax
        let brightness = colorMax
        
        return HSV(hue: hue, saturation: saturation, brightness: brightness)
    }
}

struct HSV {
    var hue: Float
    var saturation: Float
    var brightness: Float
    
    func toRGB() -> RGB {
        let chroma = brightness * saturation
        let colorMin = brightness - chroma
        let colorValue = chroma * abs(1 - abs((hue * 6).remainder(dividingBy: 2) - 1))
        
        let colorSector = Int(floor(hue * 6))
        
        var rgb = RGB(red: colorMin, green: colorMin, blue: colorMin)
        
        switch colorSector {
        case 0:
            rgb = RGB(red: chroma + colorMin, green: colorValue + colorMin, blue: colorMin)
            break
        case 1:
            rgb = RGB(red: colorValue + colorMin, green: chroma + colorMin, blue: colorMin)
            break
        case 2:
            rgb = RGB(red: colorMin, green: chroma + colorMin, blue: colorValue + colorMin)
            break
        case 3:
            rgb = RGB(red: colorMin, green: colorValue + colorMin, blue: chroma + colorMin)
            break
        case 4:
            rgb = RGB(red: colorValue + colorMin, green: colorMin, blue: chroma + colorMin)
            break
        case 5:
            rgb = RGB(red: chroma + colorMin, green: colorMin, blue: colorValue + colorMin)
            break
        default:
            break
        }

        return rgb
    }
}

struct Color {
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    func rgb() -> RGB {
        return RGB(red: red, green: green, blue: blue)
    }
    
    func hsv() -> HSV {
        return RGB(red: red, green: green, blue: blue).toHSV()
    }
    
    init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(hue: Float, saturation: Float, brightness: Float, alpha: Float = 1) {
        let rgb = HSV(hue: hue, saturation: saturation, brightness: brightness).toRGB()
        
        red = rgb.red
        blue = rgb.blue
        green = rgb.green
        self.alpha = alpha
    }
}
