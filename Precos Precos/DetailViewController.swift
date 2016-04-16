//
//  DetailViewController.swift
//  Precos Precos
//
//  Created by TmRocha89 on 06/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nomeLbl: UILabel!
    @IBOutlet weak var divisaoLbl: UILabel!
    @IBOutlet weak var descricaoLbl: UILabel!
    @IBOutlet weak var tblPrecos: UITableView!
    
    @IBOutlet weak var layoutView: UIScrollView!
    
    let imageRepo = ImagemRepository()
    let precoRepo = PrecoRepository()
    var precos:[Preco] = [Preco]()
    var produto:Produto?

    override func viewDidLoad() {
        super.viewDidLoad()
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: "screenEdgeGoBack:")
        edgePan.edges = .Left
        
        view.addGestureRecognizer(edgePan)
        precos = precoRepo.getPrecos(produto!.id!)
        self.modalTransitionStyle = .FlipHorizontal
    }
    
    func screenEdgeGoBack(sender: UIScreenEdgePanGestureRecognizer) {
        if (sender.state == .Ended) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nomeLbl.text = produto!.nome
        divisaoLbl.text = produto!.divisao!.nome
        descricaoLbl.text = produto!.obs
        showImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //returning to view
    override func viewWillAppear(animated: Bool) {
        tblPrecos.reloadData()
        //self.layoutView.backgroundColor = UIColor.blackColor()
        self.layoutView.pagingEnabled = true
    }
    
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return precos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        let emCampanha:String = (precos[indexPath.row].eCampanha != nil) ? " em campanha" : ""
                
        cell.textLabel?.text = "€ " + (precos[indexPath.row].valor!.stringValue) + emCampanha
        let loja = precos[indexPath.row].loja
        if(loja != nil){
            cell.detailTextLabel?.text = (loja?.nome)! + " - " + (loja?.local)!
        }
        
        
        return cell
    }
    
    func showImages() -> Void {
        let width = self.layoutView.frame.width
        let heigth = self.layoutView.frame.height
        var yPosition:CGFloat = 0
        let images = imageRepo.getAll((produto?.id)!)
        for image in images {
            if( image.imageData != nil){
                let uiImage = UIImage(data: image.imageData!)
                let imageView = UIImageView(image: uiImage)
                imageView.frame.size.width = width //self.layoutView.frame.width
                imageView.frame.size.height = heigth //self.layoutView.frame.width / 1.5
                imageView.frame.origin.x = 0
                imageView.frame.origin.y = yPosition
                imageView.contentMode = .ScaleAspectFit
                yPosition += imageView.frame.size.height
                self.layoutView.addSubview(imageView)
            }
        }
        let comp:Double = Double(self.layoutView.frame.width)
        self.layoutView.contentSize = CGSize(width: comp, height: Double(yPosition))
    }
    
}
