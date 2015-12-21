//
//  AddViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/10/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import AVFoundation
import Parse


class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var AddImg: UIImageView!
    @IBOutlet weak var Add_name: UITextField!
    @IBOutlet weak var Add_description: UITextField!
    
    @IBOutlet var dateTime_Field: UITextField!
    
    var date_time:String = ""
    var plan =  Plan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //self.navigationController?.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
        //self.navigationController?.navigationItem.hidesBackButton = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_Siguiente(sender: UIButton) {
        
        
        let nombre = Add_name.text
        let descripcion = Add_description.text
        let date = dateTime_Field.text
        
        
        if nombre!.isEmpty || descripcion!.isEmpty
        {
            let alert:UIAlertController = UIAlertController(title: "Information", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(actionOK)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            
            let geoPoint = PFGeoPoint()
            
            let imgRezise = resizeImage(AddImg.image!, newWidth: 500)
            
            let imgData = UIImagePNGRepresentation(imgRezise)
            let imgParseFile = PFFile(name: "img.png", data: imgData!)
            
            plan.title = nombre
            plan.descripcion = descripcion
            plan.date = date
            plan.geoPoint = geoPoint
            plan.image = imgParseFile
            
            self.performSegueWithIdentifier("map", sender: self)
            
        }
        
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
        AddImg.image = temp
        self.dismissViewControllerAnimated(true, completion: {} )
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "map"{
            print("pasar a mapa")
            let pasar = segue.destinationViewController as! AddMapViewController
            pasar.toPlan = self.plan
            
        }
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func cancel_add(sender: AnyObject) {
        let alert:UIAlertController = UIAlertController(title: "Warnning", message: "Exit create plan.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOK:UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
            self.performSegueWithIdentifier("cancel_add", sender: self)
        }
        let actionCancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func date_time(sender: AnyObject) {
        DatePickerDialog().show("Date Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
            let strDate = dateFormat.stringFromDate(date)
            var fecha_c = [String]()
            let date = String(strDate)
            fecha_c = date.componentsSeparatedByString(" ")
            self.dateTime_Field.text = fecha_c[0] + " " + fecha_c[1] + " " + fecha_c[2]
            self.date_time = fecha_c[0] + " " + fecha_c[1] + " " + fecha_c[2]
        }

    }
}
