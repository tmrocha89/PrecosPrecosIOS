//
//  UserRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 08/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class ServerRepository {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func save(address:String, port:String, username:String, password:String) -> Void {
        let context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Server", inManagedObjectContext: context)
        
        let server = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        server.setValue(address, forKey: "address")
        server.setValue(port, forKey: "port")
        server.setValue(username, forKey: "username")
        server.setValue(password, forKey: "password")
        
        do{
            try context.save()
            print("Server guardado com sucesso")
        } catch let error as NSError {
            print(error)
        }
    }
    
    func hasRegister() -> Bool {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Server")
        
        do{
            let result = try context.executeFetchRequest(fetch)
            return (result.count > 0)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func getServer() -> Server? {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Server")
        
        do{
            let result = try context.executeFetchRequest(fetch)
            let users = result as! [Server]
            return users[0]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
    
}