//
//  CoreDataManager+User.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import CoreData

extension CoreDataManager {
    
    /// Genera un ID único para un nuevo usuario
    func generateNewUserId() -> Int32 {
        do {
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            let results = try context.fetch(fetchRequest)
            if let lastUser = results.first {
                return lastUser.id + 1
            }
            return 1
        } catch {
            debugPrint("Error generating new user ID: \(error)")
            return 1
        }
    }
    
    func saveUserEntity(with model: UserModel) throws {
        debugPrint("Starting saveUserEntity with id: \(model.id)")
        
        let entity = UserEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.firstName = model.firstName
        entity.lastName = model.lastName
        entity.cellphoneNumber = model.cellphoneNumber
        entity.email = model.email
        
        do {
            try context.save()
            debugPrint("User saved successfully")
        } catch {
            debugPrint("Failed to save user entity: \(error)")
            throw error
        }
    }
    
    func fetchUsers() throws -> [UserModel] {
        debugPrint("Starting fetchUsers")
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            
            let users: [UserModel] = userEntities.map {
                UserModel(
                    id: $0.id,
                    name: $0.name,
                    firstName: $0.firstName,
                    lastName: $0.lastName,
                    cellphoneNumber: $0.cellphoneNumber,
                    email: $0.email
                )
            }
            
            return users
        } catch {
            debugPrint("Failed to fetch users: \(error)")
            throw error
        }
    }
    
    func updateUserEntity(id: Int32, with model: UserModel) throws {
        debugPrint("Starting updateUserEntity with id: \(id)")
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let entity = results.first else {
                let errorMsg = "User with id \(id) not found"
                debugPrint(errorMsg)
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: errorMsg])
            }
            
            entity.name = model.name
            entity.firstName = model.firstName
            entity.lastName = model.lastName
            entity.cellphoneNumber = model.cellphoneNumber
            entity.email = model.email
            
            try context.save()
            debugPrint("User updated successfully")
        } catch {
            debugPrint("Failed to update user entity: \(error)")
            throw error
        }
    }
    
    func deleteUserEntity(id: Int32) throws {
        debugPrint("Starting deleteUserEntity with id: \(id)")
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let entity = results.first else {
                let errorMsg = "User with id \(id) not found"
                debugPrint(errorMsg)
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: errorMsg])
            }
            
            context.delete(entity)
            try context.save()
            debugPrint("User deleted successfully")
        } catch {
            debugPrint("Failed to delete user entity: \(error)")
            throw error
        }
    }
    
    func deleteAllUsers() throws {
        debugPrint("Starting deleteAllUsers")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let batch = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batch)
            try context.save()
            debugPrint("All users deleted successfully")
        } catch {
            debugPrint("Failed to delete all users: \(error)")
            throw error
        }
    }
}
