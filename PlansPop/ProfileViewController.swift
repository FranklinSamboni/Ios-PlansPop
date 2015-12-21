//
//  ProfileViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/14/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet var sex: UITextField!
    @IBOutlet var birth: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var save_button: UIButton!
    @IBOutlet var cancel_button: UIButton!
    @IBOutlet var select_sex: UISegmentedControl!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    @IBOutlet var photo_button: UIButton!
    @IBOutlet var AddImg: UIImageView!
    
    var sexo:String = ""
    let user = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actIndicator.hidesWhenStopped = true
        name.userInteractionEnabled = false
        sex.userInteractionEnabled = false
        birth.userInteractionEnabled = false
        email.userInteractionEnabled = false
        username.userInteractionEnabled = false
        save_button.hidden = true
        cancel_button.hidden = true
        select_sex.hidden = true
        name.text = String (user!.objectForKey("name")!)
        sex.text = String (user!.objectForKey("sex")!)
        sexo = String (user!.objectForKey("sex")!)
        birth.text = String (user!.objectForKey("b_date")!)
        if user!.objectForKey("photo") != nil {
        let userImageFile = user!.objectForKey("photo") as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let images = UIImage(data:imageData)
                    self.AddImg.image = images
                }
            }
        }
        }
        email.text = user!.email
        username.text = user!.username
        photo_button.hidden = true
        
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
        self.performSegueWithIdentifier("log_out_profile", sender: self)
    }
    @IBAction func settings(sender: AnyObject) {
        name.userInteractionEnabled = true
        name.borderStyle = UITextBorderStyle.RoundedRect
        sex.hidden = true
        birth.userInteractionEnabled = true
        birth.borderStyle = UITextBorderStyle.RoundedRect
        email.userInteractionEnabled = false
        save_button.hidden = false
        cancel_button.hidden = false
        photo_button.hidden = false
        if self.sexo == "Mujer" {
            select_sex.selectedSegmentIndex = 0
        }else{
            select_sex.selectedSegmentIndex = 1
        }
        select_sex.hidden = false
    }

    @IBAction func Cancel(sender: AnyObject) {
        name.userInteractionEnabled = false
        name.borderStyle = UITextBorderStyle.None
        select_sex.hidden = true
        sex.hidden = false
        birth.userInteractionEnabled = false
        birth.borderStyle = UITextBorderStyle.None
        cancel_button.hidden = true
        save_button.hidden = true
        photo_button.hidden = true
        
    }
    @IBAction func Save(sender: AnyObject) {
        
        save_button.hidden = true
        cancel_button.hidden = true
        actIndicator.startAnimating()
        self.sex.text = self.sexo
        self.user!.username = self.username.text
        self.user!["name"] = self.name.text
        self.user!["sex"] = self.sexo
        self.user!["b_date"] = self.birth.text
        let imgRezise = resizeImage(AddImg.image!, newWidth: 500)
        let imgData = UIImagePNGRepresentation(imgRezise)
        let imgParseFile = PFFile(name: username.text! + ".png", data: imgData!)
        self.user!["photo"] = imgParseFile
        self.user?.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            if success {
                self.actIndicator.stopAnimating()
                
                self.Cancel(sender)
            
            }else{
                print(error)
                let alert:UIAlertController = UIAlertController(title: "Error", message: "Unable to save changes.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(actionOK)
                
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func sex_change(sender: AnyObject) {
        switch select_sex.selectedSegmentIndex {
        case 0:
            sexo = "Mujer"
        case 1:
            sexo = "Hombre"
        default:
            break
        }

    }
    
    
    @IBAction func edit_birthd(sender: AnyObject) {
        DatePickerDialog().show("BirthDate", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
            let strDate = dateFormat.stringFromDate(date)
            var fecha_c = [String]()
            let date = String(strDate)
            fecha_c = date.componentsSeparatedByString(" ")
            self.birth.text = fecha_c[0]
        }

    }
    @IBAction func photo_selected(sender: UIButton) {
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
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        AddImg.image = temp
        self.dismissViewControllerAnimated(true, completion: {} )
    }
    

}
