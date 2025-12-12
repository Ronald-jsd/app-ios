//
//  ValidationHelper.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import Foundation

class ValidationHelper {
    
    /// Valida formato de correo electrónico válido
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    /// Valida que el celular tenga exactamente 9 dígitos y empiece con 9
    static func isValidCellphone(_ value: String) -> Bool {
        return value.count == 9 && value.starts(with: "9")
    }
    
    /// Valida que el texto contenga solo números
    static func isOnlyDigits(_ text: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        return !text.isEmpty && text.unicodeScalars.allSatisfy { digits.contains($0) }
    }
    
    /// Valida nombre completo: solo letras (incluyendo ñ, tildes y espacios)
    static func isValidFullName(_ text: String) -> Bool {
        // Permite letras (incluyendo caracteres acentuados y ñ), espacios y guiones
        // Usa CharacterSet para incluir todos los caracteres Unicode de letras
        let lettersAndSpaces = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: "-"))
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        // Verificar que no esté vacío después de trim
        guard !trimmedText.isEmpty else { return false }
        
        // Verificar que todos los caracteres sean letras, espacios o guiones
        return text.unicodeScalars.allSatisfy { lettersAndSpaces.contains($0) }
    }
    
    /// Valida que el campo no esté vacío
    static func isNotEmpty(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
