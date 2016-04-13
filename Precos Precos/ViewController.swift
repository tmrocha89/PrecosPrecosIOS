//
//  ViewController.swift
//  Precos Precos
//
//  Created by TmRocha89 on 04/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    let network = Network()
    let lojaRepo:LojaRepository = LojaRepository()
    let produtoRepo:ProdutoRepository = ProdutoRepository()
    let serverRepo:ServerRepository = ServerRepository()
    let imageRepo = ImagemRepository()
    let precoRepo = PrecoRepository()
    var hasDownloaded = false;
    
    override func viewDidAppear(animated: Bool) {
        /*
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = "Ola"
        notification.alertLaunchImage = "NoProduct.jpg"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        */
        
        if(!serverRepo.hasRegister()){
            network.authentication(setup)
            hasDownloaded = true
            //self.performSegueWithIdentifier("ServerView", sender: self)
        }else {
            if (!hasDownloaded){
                network.authentication(setup)
                hasDownloaded = true
            }
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("oiiiiiii")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtoRepo.getTotal()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let productCell : ProdutoCell = tableView.dequeueReusableCellWithIdentifier("ProdutoCell") as! ProdutoCell
        let produto = produtoRepo.getProdutoByIndex(indexPath.row)
        var cheaperPrice:Preco? = nil
        var coverImage:Imagem? = nil
        
        if produto != nil {
            cheaperPrice = precoRepo.getCheaperFor(produto!.id!)// produto!.getCheaperPrice()
            coverImage = imageRepo.getCover(produto!.id!)
        }
        
        
        var image:NSData? = nil
        if coverImage != nil {
            image = coverImage!.imageData
        }
        
        productCell.setCell(produto!.nome!, price: cheaperPrice, description: produto!.obs!, image: image)
        
        return productCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let produto = produtoRepo.getProdutoByIndex(indexPath.row)
        
        let detailedViewController : DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        detailedViewController.produto = produto
        
        self.presentViewController(detailedViewController, animated: true, completion: nil)
    }
    
    func setup(authenticated:Bool?, error:ErrorType?) -> Void {
        network.getLojas(setupLojas)
    }
    
    func setupProdutos(json:NSMutableArray?, error:ErrorType?)->Void {
        var img = ""
        var i=0
        if(error == nil) {
            for jProd in json! {
                if(i==0){
                    img = produtoRepo.save(jProd as! NSDictionary, callback: refreshUI)!.id!
                    i++
                } else {
                produtoRepo.save(jProd as! NSDictionary, callback: refreshUI)
                }
            }
        }
        refreshUI()
    }

    
    func setupLojas(json:NSMutableArray?, error:ErrorType?)->Void {
        if (error == nil) {
            for loja in json! {
                let id = loja["_id"] as! String
                let nome = loja["nome"] as! String
                let local = loja["local"] as! String
                lojaRepo.save(id, nome: nome, local: local)
            }
            network.getProduto(setupProdutos)
        }
    }

    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            self.tblView.reloadData()
        });
    }

        
}

