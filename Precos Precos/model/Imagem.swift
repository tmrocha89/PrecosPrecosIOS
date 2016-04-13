//
//  Imagem.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import Foundation
import CoreData


class Imagem: NSManagedObject {

    func add(id:String) -> Void {
        print("TODO: add image")
    }
    
    func setImage(data:NSData) -> Void {
        self.imageData = data
    }
    
}
