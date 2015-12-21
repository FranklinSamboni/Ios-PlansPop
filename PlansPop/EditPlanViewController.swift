//
//  EditPlanViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/14/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class EditPlanViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    
    var plan: Plan?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var assist: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var date_field: UITextField!
    
    var date_time:String = ""
    var delete_plan: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        place.userInteractionEnabled = false
        name.text = plan?.title
        desc.text = plan?.descripcion
        
        //let dateFormat = NSDateFormatter()
        //dateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
        
        //let fe = dateFormat.dateFromString((plan?.date)!)
        date_field.text = plan?.date
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func btn_Galeria(sender: UIButton) {
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        self.presentViewController(imageFromSource, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        img.image = temp
        self.dismissViewControllerAnimated(true, completion: {} )
    }
    
    @IBAction func btn_siguiente(sender: UIButton) {
        
        plan?.title = self.name.text
        plan?.descripcion = self.desc.text
        
        
        
        plan?.date = date_time
        
        let imgRezise = resizeImage(img.image!, newWidth: 500)
        
        let imgData = UIImagePNGRepresentation(imgRezise)
        let imgParseFile = PFFile(name: "img.png", data: imgData!)
        
        plan?.image = imgParseFile
        
        self.performSegueWithIdentifier("edit_lugar", sender: self)
        
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "edit_lugar"{
            print("pasar a mapa")
            let pasar = segue.destinationViewController as! EditLugarViewController
            pasar.editPlan = self.plan!
            
        }
    }
    @IBAction func edit_date(sender: AnyObject) {
        DatePickerDialog().show("Date Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
            let strDate = dateFormat.stringFromDate(date)
            var fecha_c = [String]()
            let date = String(strDate)
            fecha_c = date.componentsSeparatedByString(" ")
            self.date_field.text = fecha_c[0] + " " + fecha_c[1] + " " + fecha_c[2]
            self.date_time = fecha_c[0] + " " + fecha_c[1] + " " + fecha_c[2]
        }

    }
    
    @IBAction func delete_plan(sender: AnyObject) {
        let alert:UIAlertController = UIAlertController(title: "Warnning", message: "Sure you want to delete.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOK:UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
            let query = PFQuery(className: "Plan")
            query.whereKey("objectId", equalTo: (self.plan?.id_Plan)!)
            query.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    if let objects = objects {
                        for object in objects {
                            self.delete_plan = object
                            print(objects.count)
                            print(object.objectForKey("nombre") as! String)
                            object.deleteInBackgroundWithBlock{(succes: Bool, error: NSError?) -> Void in
                                
                                if succes {
                                    print("elimino")
                                    
                                }else{
                                    
                                }
                            }
                        }
                    }
                }else{
                    print("errores")
                }
                
            }

            self.performSegueWithIdentifier("delete_s", sender: self)
        }
        let actionCancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
            }
}

