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
    
    static let ones       = ["ноль", "одна", "две", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять"]
    static let teens      = ["десять", "одинадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать"]
    static let tens       = [empty, empty, "двадцать", "тридцать", "сорок", "пятьдесят", "шестьдесят", "семьдесят", "восемьдесят", "девяносто"]
    static let hundredths = [empty, "сто", "двести", "триста", "четыреста", "пятьсот", "шестьсот", "семьсот", "восемьсот", "девяьсот"]
    static let thousands  = [empty, "тысяча"]
    static let number     = [ones, tens, hundredths, thousands]
    
    static let integerSuffix            = ["целых", "целая"]
    static let emptyFractionSuffix      = [empty, empty]
    static let onesFractionSuffix       = ["десятых", "десятая"]
    static let tensFractionSuffix       = ["сотых", "сотая"]
    static let hundredthsFractionSuffix = ["тысячных", "тысячная"]
    static let fractionSuffix           = [emptyFractionSuffix, onesFractionSuffix, tensFractionSuffix, hundredthsFractionSuffix]
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
            fraction = getDigitsFromString(removeLeadingZeros(fractionString))
        }
        else {
            integer = NumberConverter.getDigitsFromString(string)
        }
        
        var text = (number < 0 ? Words.minus + " " : Words.empty)
        text.append(digitsToText(integer) + (integer.last == 1 ? Words.integerSuffix.last! : Words.integerSuffix.first!) + " ")
        //text.append(digitsToText(fraction, lenMax: Words.number.count - 1) + (fraction.last == 1 ? Words.fractionSuffix[fraction.count].last! : Words.fractionSuffix[fraction.count].first!))
        
        return text
    }
    
    private static func removeLeadingZeros(_ string: String) -> String {
        var newString = string
        
        while newString.first == "0" {
            newString.removeFirst()
        }
        
        return newString
    }

    private static func getDigitsFromString(_ string: String) -> [Int] {
        return string.compactMap {
            return $0.wholeNumberValue
        }
    }

    private static func digitsToText(_ digits: [Int], lenMax: Int = Words.number.count) -> String {
        let reversedDigits = [Int](digits.reversed())
     
        var text = ""
        var digitPosition = (lenMax < digits.count ? lenMax : digits.count) - 1

        while 0 <= digitPosition {
            var word = ""

            if digitPosition == 1 && reversedDigits[digitPosition] == 1 {
                word = Words.teens[reversedDigits[digitPosition - 1]]
                digitPosition = 0
            }
            else {
                word = Words.number[digitPosition][reversedDigits[digitPosition]]
            }

            if !word.isEmpty {
                text.append(word + " ")
            }

            digitPosition -= 1
        }

        return text
    }
}
