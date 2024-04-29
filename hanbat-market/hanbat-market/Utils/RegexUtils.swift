//
//  RegexUtils.swift
//  hanbat-market
//
//  Created by dongs on 4/29/24.
//

import Foundation

struct RegexUtils {
    static func isValidStudentEmail(_ email: String) -> Bool {
        let emailRegex = #"^\d+@edu\.hanbat\.ac\.kr$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
