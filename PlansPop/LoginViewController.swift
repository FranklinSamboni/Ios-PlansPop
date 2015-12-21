//
//  LoginViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/8/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet var Image: UIImageView!
    @IBOutlet var user: UITextField!
    @IBOutlet var pass: UITextField!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    @IBOutlet var login_button: UIButton!
    
    //var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        self.actIndicator.hidesWhenStopped = true
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func login(sender: AnyObject) {
        
        login_button.hidden = true
        
        actIndicator.startAnimating()
        let username = self.user.text
        let password = self.pass.text
        
        if (username!.utf16.count < 4 || password!.utf16.count < 4){
            
            let alert:UIAlertController = UIAlertController(title: "Invalid", message: "Username must be greater then 4 and password must be greater then 4.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(actionOK)
            actIndicator.stopAnimating()
            
            login_button.hidden = false
            presentViewController(alert, animated: true, completion: nil)
            
            
        }else{
        
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user, error) -> Void in
            
                if ((user) != nil){
                    self.actIndicator.stopAnimating()
                   
                    
                    self.performSegueWithIdentifier("index", sender: self)
                
                }else{
                    
                    let alert:UIAlertController = UIAlertController(title: "Error", message: "Username and password invalid.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.actIndicator.stopAnimating()
                    
                    self.login_button.hidden = false
                    self.presentViewController(alert, animated: true, completion: nil)
                
                    
                
                }
            })
        
        }
        
    }

    @IBAction func register(sender: AnyObject) {
        
        
    }
    @IBAction func remember(sender: AnyObject) {
        
        
    }
}
