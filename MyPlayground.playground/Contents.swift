import Foundation

enum Converter {
    static let Empty = ""

    static let ones       = ["ноль", "один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять"]
    static let specials   = ["десять", "одинадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать"]
    static let tens       = [Empty, Empty, "двадцать", "тридцать", "сорок", "пятьдесят", "шестьдесят", "семьдесят", "восемьдесят", "девяносто"]
    static let hundredths = [Empty, "сто", "двести", "триста", "четыреста", "пятьсот", "шестьсот", "семьсот", "восемьсот", "девяьсот"]
    static let limits     = [Empty, "тысяча"]

    static var text       = [ones, tens, hundredths, limits]
    
    //static let ones = ["", "one", "tow", "three", "four", "five", "six", "seven", "eight", "nine"]
    //static let tens = ["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
}

func stringToDigits(_ string: String) -> [Int] {
    return string.reversed().compactMap {
        return $0.wholeNumberValue
    }
}

func stringNumberToText(_ stringNumber: String) -> String {
    let digits = stringToDigits(stringNumber)
    
    var textNumber = ""
    var i = digits.count - 1
    var run = true

    while 0 <= i && run {
        var word = ""

        if i == 1 && digits[i] == 1 {
            word = Converter.specials[digits[i - 1]]

            run = false
        }
        else {
            word = Converter.text[i][digits[i]]
        }

        if word != Converter.Empty {
            textNumber += word + " "
        }

        i -= 1
    }

    return textNumber
}

func numberToText(number: Double) -> String {
    let string = String(number)
    
    var integer = ""
    var fraction = ""
    
    if let firstIndex = string.firstIndex(of: ".") {
        integer = String(string[..<firstIndex])
        fraction = String(string[string.index(after: firstIndex)...])
    }
    else {
        integer = string
    }

    return stringNumberToText(integer) + "целых " + stringNumberToText(fraction)
}

let number = 0.1312

print(numberToText(number: number))
