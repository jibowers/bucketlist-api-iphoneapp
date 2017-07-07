//
//  SecondViewController.swift
//  BucketlistAPITester
//
//  Created by appleone on 7/6/17.
//  Copyright © 2017 jbowers. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var myInputField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myInputField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(textFeild: UITextField) {
        print("clearing status label")
        statusLabel.text = ""
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        let myText = myInputField.text
        
        statusLabel.text = ""
        
        let url = NSURL(string: "http://jib:germanium@ec2-54-213-17-255.us-west-2.compute.amazonaws.com:8000/bucketlists/")
        
        
        let json = ["name":myText!]

        
        // create post request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        // insert json data to the request
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            guard error == nil && data != nil else {   // check for fundamental networking error
                print("error=\(error)")
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue()){
                    /* Do UI work here */
                    self.statusLabel.text = "Something is wrong. Please try again later."
                }
                return
            }
            
            let httpStatus = response as? NSHTTPURLResponse
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            if httpStatus!.statusCode != 201{           // check for http errors
                print("statusCode should be 201, but is \(httpStatus!.statusCode)")
                print("response = \(response)")

                var errorMessage = ""
                if responseString!.lowercaseString.rangeOfString("already exists") != nil{
                    errorMessage = "Whoops, that already exists in the database!"
                }else{
                    errorMessage = "there was an error, try again later?"
                }
                
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue()){
                    /* Do UI work here */
                    self.statusLabel.text = errorMessage
                }
            }else{
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue()){
                    /* Do UI work here */
                    self.statusLabel.text = "Thanks for submitting!"
                    self.myInputField.text = "Enter something else"
                }
            }
        }
        task.resume()
        
    }
   

}

