//
//  ViewController.swift
//  NetworkSessionSample
//
//  Created by Saeid.mhd@gmail on 4/15/17.
//  Copyright © 2017 Saeid mohammadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate,URLSessionDataDelegate,URLSessionDelegate {
    

    @IBOutlet weak var idicator: UIActivityIndicatorView!
    

    
    @IBOutlet weak var FirstName: UILabel!
   
    
    

    
     var currentElementName:String = ""
     var elementValue: String = ""
     var parser = XMLParser()
     var expectedContentLength = 0
     var buffer:NSMutableData = NSMutableData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          makeGetCall()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeGetCall() {
        
        
        
        let AppSign = "05b14e27-f2cd-4329-8269-cbc62b182e78"
        let jsonString = " [{\"Username\":\"ajdari.j@chmail.com\",\"Password\":\"252579\"}]"
        let methodName = "ValidateUser"
        
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><%@ xmlns='http://tempuri.org/'><AppSign>%d</AppSign><jsonString>%@</jsonString></%@></soap:Body></soap:Envelope>", methodName, AppSign, jsonString, methodName)
        
        let url = URL(string: "http://login.mahaksoft.com/loginservices.asmx?op=ValidateUser")
        
        let soapMessage = text
        let msgLength = String(describing: soapMessage.characters.count)
        var request = URLRequest(url: url!)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let session = URLSession.shared // or let session = URLSession(configuration: URLSessionConfiguration.default)
        
        self.idicator.startAnimating()
        
        
        let task =  session.dataTask(with: request) { (data, resp, error) in
            
            
            
            if let data = data {
                
                
                
                let xmlParser = XMLParser(data: data as Data)
                xmlParser.delegate = self
                xmlParser.parse()
            }
        }
        
        
        task.resume()
        
        
        }
    
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementValue = "";
        currentElementName = elementName
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        let jsonStr = elementValue
        
        var dictonary:NSDictionary?
        
        if let data = jsonStr.data(using: String.Encoding.utf8) {
            
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                
                if let dictonary = dictonary
                {
                    let userObject = Json4Swift_Base(dictionary:dictonary)
                    print(userObject!.userInfo![0].firstName!)
                    
                    DispatchQueue.main.async {
                        
                        self.FirstName.text = userObject!.userInfo![0].firstName!
                        self.FirstName.textAlignment = .right
                        self.idicator.stopAnimating()
                      
                        
                    }
                    
                   
                    
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName == "ValidateUserResult" {
            self.elementValue += string
        }
    }
    
    
    }



