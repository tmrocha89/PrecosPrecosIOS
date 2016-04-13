//
//  Loja+CoreDataProperties.swift
//  Precos Precos
//
//  Created by TmRocha89 on 09/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Loja {

    @NSManaged var id: String?
    @NSManaged var local: String?
    @NSManaged var nome: String?

}
