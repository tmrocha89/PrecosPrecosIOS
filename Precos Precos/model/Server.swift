//
//  Server.swift
//  Precos Precos
//
//  Created by TmRocha89 on 11/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import Foundation
import CoreData


class Server: NSManagedObject {

    func getUsername() -> String {
        return (self.username != nil) ? self.username! : ""
    }
    
    func getPassword() -> String {
        return (self.password != nil) ? self.password! : ""
    }
    
    func getAddress() -> String {
        return (self.address != nil) ? self.address!+":"+self.port! : ""
    }
}
