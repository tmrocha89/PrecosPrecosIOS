//
//  DivisaoRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class DivisaoRepository {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func save(jDivisao:NSDictionary) -> Divisao? {
        
        let id = jDivisao["_id"] as! String
        
        if let divisao = getByID(id) {
            return divisao
        }
        
        let nome = jDivisao["nome"] as! String
        let context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Divisao", inManagedObjectContext: context)
        
        let divisao = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        divisao.setValue(id, forKey: "id")
        divisao.setValue(nome, forKey: "nome")
        
        do{
            try context.save()
            let divisaoObj = divisao as! Divisao
            print("Divisao \(divisaoObj.nome) guardada com sucesso")
            return divisaoObj
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func getByID(id:String) -> Divisao? {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Divisao")
        fetch.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            let result = try context.executeFetchRequest(fetch)
            let divisoes = result as! [Divisao]
            return (divisoes.count > 0 ? divisoes[0] : nil)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
    
    
}
