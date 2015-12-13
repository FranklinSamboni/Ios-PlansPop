//
//  DetailsViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/9/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {

    var plan: Plan?
    
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var date: UILabel!
    @IBOutlet var hour: UILabel!
    @IBOutlet var place: UITextView!
    @IBOutlet var assist: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = plan?.title
        desc.text = plan?.descripcion
        var fecha_c = [String]()
        fecha_c = (plan?.date.componentsSeparatedByString(" "))!
        date.text = fecha_c[0]
        hour.text = fecha_c[1] + fecha_c[2]
        place.text = plan?.place
        let userImageFile = (plan?.image)! as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let images = UIImage(data:imageData)
                    self.img.image = images
                }
            }}

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

    @IBAction func Assist(sender: AnyObject) {
    }
}
