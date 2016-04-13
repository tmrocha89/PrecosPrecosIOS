//
//  Server+CoreDataProperties.swift
//  Precos Precos
//
//  Created by TmRocha89 on 11/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Server {

    @NSManaged var password: String?
    @NSManaged var username: String?
    @NSManaged var port: String?
    @NSManaged var address: String?

}
