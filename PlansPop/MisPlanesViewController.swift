//
//  MisPlanesViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/9/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class MisPlanesViewController: UIViewController {

    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = false

        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func log_out(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("log_out", sender: self)
        
        
    }

}
