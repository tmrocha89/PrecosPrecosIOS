//
//  ImagemRepository.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit
import CoreData

class ImagemRepository {
    
    private var imagens = [Imagem]()
    private let network:Network = Network()
    private let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //private var lixo:(()->Void)
    
    func isNew(imageID:String, produtoID:String) -> Bool {
        let context = appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "Imagem")
        fetch.predicate = NSPredicate(format: "produto.id == %@ && id == %@", produtoID, imageID)
        do{
            let images:[Imagem]
            let result = try context.executeFetchRequest(fetch)
            images = result as! [Imagem]
            if (images.count > 0){
                return images[0].imageData != nil ? false : true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return true
    }
    
    func save(imagens:[String], produto:Produto, callback:(()->Void)) -> [Imagem] {
        var imagensID:[Imagem] = [Imagem]()
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Imagem", inManagedObjectContext: context)

        for imgID in imagens {
            if (isNew(imgID, produtoID: produto.id!)) {
                let imagem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
                imagem.setValue(imgID, forKey: "id")
                imagem.setValue(produto, forKey: "produto")
                do{
                    try context.save()
                    let img = imagem as! Imagem
                    print("Imagem \(img.id) guardada com sucesso")
                    network.getImage(img.id!, productID: produto.id!, callback: downloadImagem, lixxo:callback)
                    imagensID.append(img)
                    callback()
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }

        return imagensID
    }
    
    func getAll(produtoID:String) -> [Imagem] {
        var images = [Imagem]()
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Imagem")
        fetch.predicate = NSPredicate(format: "produto.id == %@", produtoID)
        
        do{
            let result = try context.executeFetchRequest(fetch)
            images = result as! [Imagem]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return images
    }
    
    func getCover(produtoID:String) -> Imagem? {
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Imagem")
        fetch.predicate = NSPredicate(format: "produto.id == %@", produtoID)
        
        do{
            let result = try context.executeFetchRequest(fetch)
            let image = result as! [Imagem]
            return (image.count > 0 ? image[0] : nil)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func downloadImagem(imageID:String,productID:String,json:NSData?, error:ErrorType?, lixo:(()->Void)!) -> Void{
        if(error == nil && json != nil) {
            let context = appDelegate.managedObjectContext
            
            let fetch = NSFetchRequest(entityName: "Imagem")
            fetch.predicate = NSPredicate(format: "id == %@", imageID)
            
            do{
                let imagesArray = try context.executeFetchRequest(fetch)
                let image = imagesArray[0] as! Imagem
                image.setImage(json!)
                try context.save()
                imagens.append(image)
                print("Imagem ja sacou")
                lixo()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
}
