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
