//
//  ProdutoRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 08/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class ProdutoRepository {
    
    private var produtos:[Produto] = [Produto]()
    private let divisaoRepo = DivisaoRepository()
    private let imageRepo = ImagemRepository()
    private let precoRepo = PrecoRepository()
    private let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func getAll() -> [Produto] {
        return self.produtos
    }
    
    func getProduto(produtoID:String) -> Produto? {
        let context = appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Produto")
        fetch.predicate = NSPredicate(format: "id == %@", produtoID)
        do {
            let results = try context.executeFetchRequest(fetch)
            return results.count > 0 ? results[0] as! Produto : nil
        } catch {
            return nil
        }
    }
    
    func getProutosByName(name: String) -> [Produto]{
        let produtosTemp = produtos.filter{produto in
            return (produto.nome?.lowercaseString.containsString(name.lowercaseString))!}
        return produtosTemp
    }
    
    func save(jProduto:NSDictionary, callback:(()->Void)) -> Produto? {
        let id = jProduto["_id"] as! String
        
        let produto = getProduto(id)
        
        if (produto != nil){
            produtos.append(produto!)
            downloadImages(jProduto["imagens"], produto: produto!, callback: callback)
            downloadPrecos(jProduto["precos"], produto: produto!, callback: callback)
            callback()
            return produto
        }
        
        let nome = jProduto["nome"] as! String
        let obs = jProduto["obs"] as! String
        let divisao = divisaoRepo.save(jProduto["divisao"] as! NSDictionary)
        
        let context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Produto", inManagedObjectContext: context)
        
        let newProduto = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        newProduto.setValue(id, forKey: "id")
        newProduto.setValue(nome, forKey: "nome")
        newProduto.setValue(obs, forKey: "obs")
        newProduto.setValue(divisao, forKey: "divisao")
        //newProduto.setValue(nil, forKey: "adquirido")
        //newProduto.setValue(nil, forKey: "precoAdquirido")
        
        do{
            try context.save()
            let produtoObj = newProduto as! Produto
            //print("Produto \(produtoObj.nome) guardada com sucesso")
            self.produtos.append(produtoObj)
            callback()
            downloadImages(jProduto["imagens"], produto: produtoObj, callback: callback)
            downloadPrecos(jProduto["precos"], produto: produtoObj, callback: callback)

            
            return produtoObj
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func downloadImages(imagens:AnyObject?, produto:Produto, callback:(()->Void)) -> Void {
        if( imagens != nil) {
            if (imagens!.count > 0){
                imageRepo.save(imagens as! [String], produto: produto, callback: callback)
            }
        }
    }
    
    func downloadPrecos(precos:AnyObject?, produto:Produto, callback:(()->Void)) -> Void {
        if( precos != nil) {
            if (precos!.count > 0){
                precoRepo.save(precos as! NSMutableArray, produto: produto, callback: callback)
            }
        }
    }
    
    func getProdutoByID(id:String) -> Produto? {
        for produto in produtos {
            if produto.id == id {
                return produto
            }
        }
        return nil
    }
    
    func getProdutoByIndex(index:Int) -> Produto? {
        return produtos[index]
    }
    
    func getTotal() -> Int {
        return produtos.count
    }
}