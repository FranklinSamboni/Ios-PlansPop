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
    
    var plan = Plan()
    
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var date: UILabel!
    @IBOutlet var hour: UILabel!
    @IBOutlet var place: UITextView!
    @IBOutlet var assist: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var assist_button: UIButton!
    
    var planRela: PFObject!
    var Rela: PFRelation!
    
    var asistiendo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = plan.title
        desc.text = plan.descripcion
        var fecha_c = [String]()
        fecha_c = (plan.date.componentsSeparatedByString(" "))
        date.text = fecha_c[0]
        hour.text = fecha_c[1] + fecha_c[2]
        place.text = plan.place
        
        print(plan.id_Plan)
        
        let query = PFQuery(className: "Plan")
        query.whereKey("objectId", equalTo: plan.id_Plan)
        query.findObjectsInBackgroundWithBlock{(parsePlan: [PFObject]?, errores: NSError?)->Void in
            
            if errores == nil {
                self.planRela = (parsePlan?.first)!
                self.relation()
            }
            
        }
        
        
        let userImageFile = plan.image
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
    
    
    func relation () {
        self.Rela = self.planRela.relationForKey("Asistentes") as PFRelation
        let q = Rela.query()
        q.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?)->Void in
            
            if(error == nil){
                let user = PFUser.currentUser()
                
                let x = (objects?.count)! as NSNumber
                self.assist.text = x.stringValue
                if let objects = objects {
                    for object in objects{
                        
                        if user?.objectId == object.objectId{
                            self.asistiendo = true
                            self.assist_button.setTitle("Attending", forState: UIControlState.Normal)
                        }
                        
                    }
                }
            }
            else{
                print("no")
                self.assist_button.setTitle("Assist", forState: UIControlState.Normal)
                
            }
            
        }
        
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
        self.Rela = self.planRela.relationForKey("Asistentes") as PFRelation
        let user = PFUser.currentUser()
        
        if(asistiendo == true){
            self.Rela.removeObject(user!)
            self.assist_button.setTitle("Assist", forState: UIControlState.Normal)
            self.asistiendo = false
        }
        else{
            self.Rela.addObject(user!)
            self.assist_button.setTitle("Attending", forState: UIControlState.Normal)
        }
        planRela.saveInBackgroundWithBlock { (exito: Bool?, error: NSError?) -> Void in
            if error == nil {
                self.relation()
            }
        }
        
    }
}
