//
//  Validation.swift
//  argus
//
//  Created by Amit Kumar Swami on 08/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import Foundation
import Result

enum ValidationType {
    case email
    case characterLength(min: Int?, max: Int?)
    case specialCharacterExist
    case upperCaseExist
    case lowerCaseExist
    case custom(regex: String, errorMessage: String)
    
    static func validate(string: String, validationType: ValidationType) -> Result<Bool, ValidationError> {
        switch validationType {
        case .email:
            if string.isValidEmail() {
                return .success(true)
            }
            return .failure(.invalidEmail)
        case let .characterLength(min, max):
            if string.characters.count < (min ?? Int.max) {
                return .failure(.shortCharacterLength)
            } else if string.characters.count > (max ?? Int.min) {
                return .failure(.longCharacterLength)
            }
            return .success(true)
        case .specialCharacterExist:
            if string.containsSpecialCharacter() {
                return .success(true)
            }
            return .failure(.specialCharacterMissing)
        case .upperCaseExist:
            if string.lowercased() == string {
                return .failure(.upperCaseMissing)
            }
            return .success(true)
        case .lowerCaseExist:
            if string.uppercased() == string {
                return .failure(.lowerCaseMissing)
            }
            return .success(true)
        case let .custom(regex, errorMessage):
            do {
                let regularExpression = try NSRegularExpression.init(pattern: regex, options: .ignoreMetacharacters)
                guard let _ = regularExpression.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.characters.count)) else { return .failure(.unknown(errorMessage)) }
                return .success(true)
            } catch {
                print(error.localizedDescription)
                return .failure(.invalidRegex)
            }
        }
    }
    
    static func validate(string: String, validations: [ValidationType]) -> Result<Bool, ValidationError> {
        for validation in validations {
            switch validate(string: string, validationType: validation) {
            case .success:
                continue
            case let .failure(error):
                return .failure(error)
            }
        }
        
        return .success(true)
    }
}

enum ValidationError: Error {
    case invalidEmail
    case shortCharacterLength
    case longCharacterLength
    case specialCharacterMissing
    case upperCaseMissing
    case lowerCaseMissing
    case invalidRegex
    case unknown(String)
}

enum LoginError: Error {
    case userCancelled
    case loginFailure
    case connectionLost
    case graphConnectionError
}
