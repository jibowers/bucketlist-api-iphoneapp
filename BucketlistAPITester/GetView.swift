
//
//  FirstViewController.swift
//  BucketlistAPITester
//
//  Created by appleone on 7/6/17.
//  Copyright © 2017 jbowers. All rights reserved.
//

import UIKit

class GetViewController: UIViewController {

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonTapped(sender: UIButton) {

        let urlWithParams = "http://jib:germanium@ec2-54-213-17-255.us-west-2.compute.amazonaws.com:8000/bucketlists/?format=json"
        
        var bucketlistInfo = ""
        //var bigDict = NSDictionary()
        
        
        // Create NSURL object
        let myUrl = NSURL(string: urlWithParams)
        
        // Create URL Request
        let request = NSMutableURLRequest(URL: myUrl!)
        
        // Set request HTTP method to GET, it could be POST as well for other purposes
        request.HTTPMethod = "GET"
        
        // Here is where you might add Authorization header value
        //
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            // Check for error
            if error != nil{
                print("error=\(error)")
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue()){
                    /* Do UI work here */
                    self.myTextView.text = "Sorry, the server is unavailable :(\nPlease try again later"
                }
                return
            }
            
            // Print out response string
            let responseString=NSString(data: data!, encoding:NSUTF8StringEncoding)
            print("responseString= \(responseString)")
            
            do{
                
                // Convert server json response to NSArray
                if let convertedJsonIntoArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray{
                    
                    for item in convertedJsonIntoArray{
                        let name = item["name"] as! String
                        bucketlistInfo += (name + "\n\n")
                    }
                    
                    
                    print("master list: " + bucketlistInfo)
                    
                    // have to do this on the main thread
                    dispatch_async(dispatch_get_main_queue()){
                        /* Do UI work here */
                        self.myTextView.text = "Do this stuff: \n\n \(bucketlistInfo)  \n *"
                    }
                    
                    
                }
            }catch let error as NSError{
                print("The error")
                print(error.localizedDescription)
                
                
            }
            
        }
        
        task.resume()
        
    }


}

