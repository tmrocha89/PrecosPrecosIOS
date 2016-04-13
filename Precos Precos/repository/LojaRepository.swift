//
//  LojaRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 08/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class LojaRepository {
    
    private var lojas = [Loja]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init() {
        loadLojas()
    }
    
    func loadLojas() -> Void {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Loja")
        
        do{
            let result = try context.executeFetchRequest(fetch)
            lojas.removeAll()
            lojas = result as! [Loja]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func isNew(id:String) -> Bool {
        for loja in lojas {
            if loja.id == id {
                return false
            }
        }
        return true
    }
    
    func save(id:String, nome:String, local:String) -> Bool {
        
        if(!isNew(id)){
            print("repetido")
            return true
        }
        
        let context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Loja", inManagedObjectContext: context)
        
        let loja = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        loja.setValue(id, forKey: "id")
        loja.setValue(nome, forKey: "nome")
        loja.setValue(local, forKey: "local")

        do {
            try context.save()
            print("loja guardada")
            loadLojas()
            return true
        } catch let error as NSError {
            print(error)
        }
        
        return false
    }
    
    func getLojaByID(id:String) -> Loja? {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Loja")
        fetch.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            let result = try context.executeFetchRequest(fetch)
            lojas.removeAll()
            lojas = result as! [Loja]
            return lojas.count > 0 ? lojas[0] : nil
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
}