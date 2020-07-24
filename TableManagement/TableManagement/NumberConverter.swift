//
//  NumberConverter.swift
//  TableManagement
//
//  Created by Admin on 18.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

private enum Words {
    static let empty = ""
    static let minus = "минус"
    static let zero  = "ноль"
    
    static let ones       = [empty, "одна", "две", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять"]
    static let teens      = ["десять", "одинадцать", "двенадцать", "тринадцать", "четырнадцать",
                             "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать"]
    static let tens       = [empty, empty, "двадцать", "тридцать", "сорок", "пятьдесят", "шестьдесят", "семьдесят", "восемьдесят", "девяносто"]
    static let hundredths = [empty, "сто"]
    static let number     = [ones, tens, hundredths]
    
    static let integerSuffix            = ["целых", "целая"]
    static let emptyFractionSuffix      = [empty, empty]
    static let tensFractionSuffix       = ["десятых", "десятая"]
    static let hundredthsFractionSuffix = ["сотых", "сотая"]
    static let fractionSuffix           = [emptyFractionSuffix, tensFractionSuffix, hundredthsFractionSuffix]
}

enum NumberConverter {
    static func toText(_ number: Float) -> String {
        var integer: [Int] = []
        var fraction: [Int] = []
        
        let string = String(number)
        
        if let firstIndex = string.firstIndex(of: ".") {
            let integerString = String(string[..<firstIndex])
            let fractionString = String(string[string.index(after: firstIndex)...])
            
            integer = getDigitsFromString(integerString)
            fraction = getDigitsFromString(fractionString)
        }
        else {
            integer = getDigitsFromString(string)
        }

        let sign = (number < 0 ? Words.minus + " " : Words.empty)
        var integerText = digitsToText(integer)
        var fractionText = digitsToText(removeFractionLeadingZeros(fraction))
        
        if !fractionText.isEmpty {
            if 1 < integer.count && integer[integer.count - 2] == 1 {
                integerText.append(Words.integerSuffix.first! + " ")
            }
            else {
                integerText.append((integer.last == 1 ? Words.integerSuffix.last! : Words.integerSuffix.first!) + " ")
            }
            
            if 1 < fraction.count && fraction[fraction.count - 2] == 1 {
                fractionText.append(Words.fractionSuffix[fraction.count].first!)
            }
            else {
                fractionText.append(fraction.last == 1 ? Words.fractionSuffix[fraction.count].last! : Words.fractionSuffix[fraction.count].first!)
            }
        }
        
        return sign + integerText + fractionText
    }
    
    private static func removeFractionLeadingZeros(_ fraction: [Int]) -> [Int] {
        var newFraction = fraction
        
        while newFraction.first == 0 {
            newFraction.removeFirst()
        }
        
        return newFraction
    }

    private static func getDigitsFromString(_ string: String) -> [Int] {
        return string.compactMap { $0.wholeNumberValue }
    }

    private static func digitsToText(_ digits: [Int]) -> String {
        let reversedDigits = [Int](digits.reversed())
     
        var text = ""
        var digitPosition = digits.count - 1

        while 0 <= digitPosition {
            var word = ""
            
            if reversedDigits.count == 1 && reversedDigits[digitPosition] == 0  {
                word = Words.zero
            }
            else {
                if digitPosition == 1 && reversedDigits[digitPosition] == 1 {
                    digitPosition = 0
                    word = Words.teens[reversedDigits[digitPosition]]
                }
                else {
                    word = Words.number[digitPosition][reversedDigits[digitPosition]]
                }
            }

            if !word.isEmpty {
                text.append(word + " ")
            }

            digitPosition -= 1
        }

        return text
    }
}
