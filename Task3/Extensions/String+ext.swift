//
//  String+ext.swift
//  Task3
//
//  Created by Вадим Сайко on 25.12.22.
//

extension String {
//    Белорусские номера с префиксами +375, 8 и просто номер
    enum Patterns: String {
        case internationalMobileNumber = "+### (##) ###-##-##"
        case countryMobileNumber = "# (###) ###-##-##"
        case noPrefixMobileNumber = "###-##-##"
    }
    func formatter() -> String {
        let number = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var mask = ""
        var index = number.startIndex
        if number.hasPrefix("3") {
            mask = Patterns.internationalMobileNumber.rawValue
        } else if number.hasPrefix("8") && number.count > 7 {
            mask = Patterns.countryMobileNumber.rawValue
        } else {
            mask = Patterns.noPrefixMobileNumber.rawValue
        }
        for character in mask where index < number.endIndex {
            if character == "#" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}
