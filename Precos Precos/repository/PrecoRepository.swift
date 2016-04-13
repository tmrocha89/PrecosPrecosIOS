//
//  PrecoRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class PrecoRepository {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let lojaRepo = LojaRepository()
    
    
    private func getCheaper(precos:[Preco]) -> Preco? {
        if (precos.count < 1) {
            return nil
        }
        var cheaper = precos[0];
        for preco in precos {
            if cheaper.getValor() > preco.getValor() {
                cheaper = preco
            }
        }
        return cheaper
    }
    
    func getCheaperFor(produtoID:String) -> Preco? {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Preco")
        fetch.predicate = NSPredicate(format: "produto.id == %@", produtoID)
        
        do{
            let result = try context.executeFetchRequest(fetch)
            let precos = result as! [Preco]
            return getCheaper(precos)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil

    }
    
    func getPrecos(produtoID:String) -> [Preco] {
        let context = appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Preco")
        fetch.predicate = NSPredicate(format: "produto.id == %@", produtoID)
        do{
            let result = try context.executeFetchRequest(fetch)
            let precos = result as! [Preco]
            return precos
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return [Preco]()
    }
    
    func isNew(precoID:String, produtoID:String) -> Bool {
        let context = appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Preco")
        fetch.predicate = NSPredicate(format: "produto.id == %@ && id == %@", produtoID, precoID)
        do{
            let result = try context.executeFetchRequest(fetch)
            let precos = result as! [Preco]
            if(precos.count > 0){
                return precos[0].valor != nil ? false : true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return true
    }
    
    func save(jPrecos:NSMutableArray, produto:Produto, callback:(()->Void)) -> [Preco] {
        var precos = [Preco]()
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Preco", inManagedObjectContext: context)
        
        for jPreco in jPrecos {
            let precoTmp = jPreco as! NSDictionary
            let idPreco = precoTmp["_id"] as! String
            if(isNew(idPreco, produtoID: produto.id!)){
                let preco = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
                preco.setValue(idPreco, forKey: "id")
                preco.setValue(precoTmp["valor"] as! Float, forKey: "valor")
                preco.setValue(precoTmp["eCampanha"] as! Bool, forKey: "eCampanha")
                let lojaID = precoTmp["loja"] as! String
                let loja = lojaRepo.getLojaByID(lojaID)
                preco.setValue(loja, forKey: "loja")
                preco.setValue(produto, forKey: "produto")
            
                do{
                    try context.save()
                    let precoObj = preco as! Preco
                    print("Preco \(precoObj.id) guardada com sucesso")
                    precos.append(precoObj)
                    callback()
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return precos
    }
    
    
    
    
}
