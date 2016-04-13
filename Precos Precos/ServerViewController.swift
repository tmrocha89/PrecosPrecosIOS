//
//  ServerViewController.swift
//  Precos Precos
//
//  Created by TmRocha89 on 11/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import UIKit

class ServerViewController: UIViewController {

    let serverRepo = ServerRepository()
    
    @IBOutlet weak var serverAddress: UITextField!
    @IBOutlet weak var serverPort: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userpassword: UITextField!
    
    
    @IBAction func goBackBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let server = serverRepo.getServer()
        serverAddress.text = server?.address
        serverPort.text = server?.port
        username.text = server?.username
        userpassword.text = server?.password
    }
    
    @IBAction func saveBtn(sender: AnyObject) {
        let name:String = username.text!
        let password:String = userpassword.text!
        let address:String = serverAddress.text!
        let port:String = serverPort.text!
        
        if ( name.isEmpty || password.isEmpty || address.isEmpty || port.isEmpty) {
            
        } else {
            serverRepo.save(address, port: port, username: name, password: password)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
}
