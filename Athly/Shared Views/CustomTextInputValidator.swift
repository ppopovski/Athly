//
//  CustomTextInputValidator.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

struct CustomTextInputValidator {
    enum ErrorCase {
        case empty
        case email

        var error: ValidationError {
            switch self {
            case .empty:
                return ValidationError.empty("This field is required")
            case .email:
                return ValidationError.email("Please enter a valid email address")
            }
        }
        
        func validate(_ input: String) -> ValidationError? {
            switch self {
            case .empty: return input.isEmpty ? error : nil
            case .email: return !input.isValidEmail ? error : nil
            }
        }
    }

    struct ValidationError: Error {
        let message: String
        
        static func empty(_ message: String) -> ValidationError {
            return ValidationError(message: message)
        }
        
        static func email(_ message: String) -> ValidationError {
            return ValidationError(message: message)
        }
    }
    
    let errorCases: [ErrorCase]
    
    func isValid(_ input: String) -> ValidationError? {
        for errorCase in errorCases {
            if let result = errorCase.validate(input) {
                return result
            }
        }
        
        return nil
    }
}

