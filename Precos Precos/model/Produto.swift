//
//  Produto.swift
//  Precos Precos
//
//  Created by TmRocha89 on 10/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import Foundation
import CoreData


class Produto: NSManagedObject {

    func getCheaperPrice() -> Preco? {
        if (precos!.count < 1) {
            return nil
        }
        var cheaper = precos![0];
        for preco in precos! {
            if cheaper.getValor() < preco.getValor() {
                cheaper = preco
            }
        }
        return cheaper
    }
    
    func getImageByID(id:String) -> Imagem?{
        for image in imagens! {
            if image.id == id {
                return image
            }
        }
        return nil
    }
    
}
