//
//  Color.swift
//  TableManagement
//
//  Created by Admin on 23.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Color {
    var red: Float {
        get {
            return rgb.red
        }
        set {
            rgb.red = newValue
            hsv = ColorConverter.rgbToHSV(rgb)
        }
    }
    
    var green: Float {
        get {
            return rgb.green
        }
        set {
            rgb.green = newValue
            hsv = ColorConverter.rgbToHSV(rgb)
        }
    }
    
    var blue: Float {
        get {
            return rgb.blue
        }
        set {
            rgb.blue = newValue
            hsv = ColorConverter.rgbToHSV(rgb)
        }
    }
    
    var hue: Float {
        get {
            return hsv.hue
        }
        set {
            hsv.hue = newValue
            rgb = ColorConverter.hsvToRGB(hsv)
        }
    }
    
    var saturation: Float {
        get {
            return hsv.saturation
        }
        set {
            hsv.saturation = newValue
            rgb = ColorConverter.hsvToRGB(hsv)
        }
    }
    
    var brightness: Float {
        get {
            return hsv.brightness
        }
        set {
            hsv.brightness = newValue
            rgb = ColorConverter.hsvToRGB(hsv)
        }
    }
    
    var alpha: Float
    
    private var rgb: RGB
    private var hsv: HSV
    
    init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        rgb = RGB(red: red, green: green, blue: blue)
        hsv = ColorConverter.rgbToHSV(rgb)
        self.alpha = alpha
    }
    
    init(hue: Float, saturation: Float, brightness: Float, alpha: Float = 1.0) {
        hsv = HSV(hue: hue, saturation: saturation, brightness: brightness)
        rgb = ColorConverter.hsvToRGB(hsv)
        self.alpha = alpha
    }
}

private struct RGB {
    var red: Float
    var green: Float
    var blue: Float
}

private struct HSV {
    var hue: Float
    var saturation: Float
    var brightness: Float
}

private enum ColorConverter {
    static func rgbToHSV(_ rgb: RGB) -> HSV {
        let colorMax = max(rgb.red, rgb.green, rgb.blue)
        let colorMin = min(rgb.red, rgb.green, rgb.blue)
        let delta = colorMax - colorMin
        
        var hue: Float = 0
        
        if delta != 0 {
            switch colorMax {
            case rgb.red:
                hue = ((rgb.green - rgb.blue) / delta).remainder(dividingBy: 6)
                break
            case rgb.green:
                hue = (rgb.blue - rgb.red) / delta + 2
                break
            default:
                hue = (rgb.red - rgb.green) / delta + 4
                break
            }
        }
        
        hue = (60 * hue < 0 ? hue + 6 : hue) / 6
        
        let saturation = colorMax == 0 ? 0 : delta / colorMax
        let brightness = colorMax
        
        return HSV(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    static func hsvToRGB(_ hsv: HSV) -> RGB {
        let chroma = hsv.brightness * hsv.saturation
        let colorMin = hsv.brightness - chroma
        let colorValue = chroma * abs(1 - abs((hsv.hue * 6).remainder(dividingBy: 2) - 1))
        let colorSector = Int(floor(hsv.hue * 6))
        
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
