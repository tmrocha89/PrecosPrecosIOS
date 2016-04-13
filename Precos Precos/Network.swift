//
//  Network.swift
//  Precos Precos
//
//  Created by TmRocha89 on 04/04/16.
//  Copyright © 2016 TmRocha89. All rights reserved.
//

import Foundation

class Network {
    
    private let serverRepo = ServerRepository()
    
    func authentication(callback:((authenticated:Bool?, error:ErrorType?)->Void)) -> Void {
        let server = serverRepo.getServer()
        print(server!.getAddress())
        let request = NSMutableURLRequest(URL: NSURL(string: "http://"+server!.getAddress()+"/auth/login")!)
        request.HTTPMethod = "POST"


        let postString = "username="+(server!.getUsername())+"&password="+(server!.getPassword())
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            //let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
            
            //let authenticated:Bool = jsonResponse["state"] == "success" ? true : false
            callback(authenticated: true, error: error)
        }
        task.resume()
    }
    
    func getLojas(callback:((json:NSMutableArray?, error:ErrorType?)->Void)!) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://"+(serverRepo.getServer()?.getAddress())!+"/api/lojas")!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                if let ipString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    
                    let jsonLojas = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSMutableArray
                    
                    callback(json: jsonLojas, error: error);
                }
            } catch {
                print("ERROR: \(error)")
                callback(json: nil, error: error);
            }
            
        }
        task.resume()
    }
    
    func getLojas(id:String, callback:((json:NSMutableArray?, error:ErrorType?)->Void)!) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://"+(serverRepo.getServer()?.getAddress())!+"/api/imagems/"+id)!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                if let ipString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    
                    let jsonLojas = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSMutableArray
                    
                    callback(json: jsonLojas, error: error);
                }
            } catch {
                print("ERROR: \(error)")
                callback(json: nil, error: error);
            }
            
        }
        task.resume()
    }
    
    func getProduto(callback:((json:NSMutableArray?, error:ErrorType?)->Void)!) -> Void {
        
        let endPointString = "http://"+(serverRepo.getServer()?.getAddress())!+"/api/produtos"
        
        print(endPointString)
        
        let url = NSURL(string: endPointString)
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler: {
            (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if (error != nil) {
                print("ERROR: \(error)")
                return
            }
            do {
                if let ipString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    print("estou aqui")
                    print("DATA: \(data)")
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSMutableArray //NSDictionary
                    
                    callback(json:jsonArray, error: nil)
                }
            } catch {
                print("ERROR: \(error)")
            }
            
        }).resume()
        
    }
    


    func getImage(imageID:String, productID:String, callback:((imageID:String, productID:String, json:NSData?, error:ErrorType?, lixo:(()->Void) )->Void)!, lixxo:(()->Void)) -> Void {
        let endPointString = "http://"+(serverRepo.getServer()?.getAddress())!+"/api/imagens/"+imageID
        
        //print(endPointString)
        
        let url = NSURL(string: endPointString)
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler: {
            (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if (error != nil) {
                print("ERROR: \(error)")
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
                var bytes = json["data"] as! String
                let range = bytes.rangeOfString(",")
                let pos = bytes.startIndex.distanceTo((range?.startIndex)!)
                bytes = (bytes as NSString).substringFromIndex(pos)
                let sendData = NSData(base64EncodedString: bytes, options: .IgnoreUnknownCharacters)

                callback(imageID: imageID, productID: productID, json:sendData, error: nil, lixo: lixxo)
                
            } catch {
                print("ERROR: \(error)")
            }
            
        }).resume()
    }
    
}