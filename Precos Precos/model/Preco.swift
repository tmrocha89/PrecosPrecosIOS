//
//  Preco.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import Foundation
import CoreData


class Preco: NSManagedObject {

    
    func ePrecoCampanha() -> Bool {
        return (self.eCampanha?.boolValue)!
    }
    
    func getValor() -> Float {
        return (self.valor?.floatValue)!
    }
}
