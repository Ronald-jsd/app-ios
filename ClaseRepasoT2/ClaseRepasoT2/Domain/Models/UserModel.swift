//
//  UserModel.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

struct UserModel {
    let id: Int32
    let name: String
    let firstName: String?
    let lastName: String?
    let cellphoneNumber: String
    let email: String
    
    init(id: Int32, name: String, firstName: String? = nil, lastName: String? = nil, cellphoneNumber: String, email: String) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.cellphoneNumber = cellphoneNumber
        self.email = email
    }
    
    /// Retorna el nombre completo combinando firstName y lastName, o usa name si están vacíos
    var fullName: String {
        if let firstName = firstName, let lastName = lastName, !firstName.isEmpty, !lastName.isEmpty {
            return "\(firstName) \(lastName)"
        }
        return name
    }
}
