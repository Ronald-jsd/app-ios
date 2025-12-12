//
//  UserEntity.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import CoreData

@objc(UserEntity)
class UserEntity: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var cellphoneNumber: String
    @NSManaged var email: String
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "User")
    }
    
    convenience init(
        context: NSManagedObjectContext,
        id: Int32,
        name: String,
        firstName: String? = nil,
        lastName: String? = nil,
        cellphoneNumber: String,
        email: String
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.cellphoneNumber = cellphoneNumber
        self.email = email
    }
}
