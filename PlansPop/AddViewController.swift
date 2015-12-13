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
    @IBOutlet weak var dateTime: UIDatePicker!
    
    
    var plan =  Plan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_Siguiente(sender: UIButton) {
        
        
        let nombre = Add_name.text
        let descripcion = Add_description.text
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd/MM/YYYY HH:mm a"
        let strDate = dateFormat.stringFromDate(dateTime.date)
        print(strDate)
        
        
        if nombre!.isEmpty || descripcion!.isEmpty
        {
            let alert:UIAlertController = UIAlertController(title: "Informacion", message: "Todos los campos son requeridos", preferredStyle: UIAlertControllerStyle.Alert)
            
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
            plan.date = strDate
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
    
    
}
