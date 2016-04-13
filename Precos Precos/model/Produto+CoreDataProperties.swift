//
//  Produto+CoreDataProperties.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Produto {

    @NSManaged var adquirido: NSNumber?
    @NSManaged var id: String?
    @NSManaged var nome: String?
    @NSManaged var obs: String?
    @NSManaged var divisao: Divisao?
    @NSManaged var imagens: [Imagem]?
    @NSManaged var precoAdquirido: Preco?
    @NSManaged var precos: [Preco]?

}
