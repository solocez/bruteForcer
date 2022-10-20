//
//  String+Extension.swift
//  bruteForcer
//
//  Created by Zakhar Sukhanov on 18.10.2022.
//

import Foundation

extension String {
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(self)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }
}
