//
//  ProdutoCell.swift
//  Precos Precos
//
//  Created by TmRocha89 on 05/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit

class ProdutoCell: UITableViewCell {

    @IBOutlet weak var productTitleLbl: UILabel!
    
    @IBOutlet weak var productPriceLbl: UILabel!
    
    @IBOutlet weak var productStoreLbl: UILabel!
    
    @IBOutlet weak var productDescriptionLbl: UILabel!
    
    @IBOutlet weak var productCoverImage: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(title:String, price:Preco?, description:String,image:NSData?) {
        self.productTitleLbl.text = title
        if (price != nil) {
            self.productPriceLbl.text = "€" + (price!.valor?.stringValue)!
            self.productStoreLbl.text = price!.loja?.nome != nil ? price!.loja!.nome : "sem loja"
        } else {
            self.productPriceLbl.text = "Sem preço"
            self.productStoreLbl.text = "Sem loja"
        }
        
        self.productDescriptionLbl.text = description
        
        if(image?.length > 0 && image != nil){
            self.productCoverImage?.image = UIImage(data: image!)
            self.productCoverImage?.layer.cornerRadius = 5
        } else {
            self.productCoverImage.image = UIImage(named: "NoProduct.jpg")
        }
    }

}
