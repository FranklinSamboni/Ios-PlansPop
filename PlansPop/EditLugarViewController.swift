//
//  EditLugarViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/14/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class EditLugarViewController: UIViewController, GMSMapViewDelegate {
    
    var editPlan = Plan()
    
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true
        let camera = GMSCameraPosition.cameraWithLatitude(editPlan.geoPoint.latitude,
            longitude: editPlan.geoPoint.longitude, zoom: 17)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        
        
        self.view = mapView
        
        let query = PFQuery(className:"Lugares")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?)->Void in
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) scores.")
                
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        let direccion = object["direccion"] as! String
                        let geoP = object["ubicacion"] as! PFGeoPoint
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(geoP.latitude, geoP.longitude)
                        marker.title = direccion
                        //marker.snippet = "Australia"
                        marker.map = mapView
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
    }
    
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        let geoCo = GMSGeocoder()
        geoCo.reverseGeocodeCoordinate(coordinate, completionHandler: {(placemarks, error) -> Void in
            
            let pla = placemarks as GMSReverseGeocodeResponse
            let resultados = pla.results() as Array
            let addres = resultados[0] as! GMSAddress
            let direccion = addres.addressLine1()
            print(direccion)
            
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            marker.title = direccion
            //marker.snippet = "Australia"
            marker.map = mapView
            
        })
        
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let alert:UIAlertController = UIAlertController(title: "Replace", message: "¿Do you want to change this place ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOK:UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(UIAlertAction)-> Void in
            
            self.editPlan.geoPoint.latitude = marker.position.latitude
            self.editPlan.geoPoint.longitude = marker.position.longitude
            self.view.hidden = true
            self.actIndicator.startAnimating()
            let query = PFQuery(className: "Plan")
            query.getObjectInBackgroundWithId(self.editPlan.id_Plan){
                (parsePlan: PFObject?, error: NSError?) -> Void in
                if error == nil && parsePlan != nil {
                    
                    parsePlan!["nombre"] = self.editPlan.title
                    parsePlan!["descripcion"] = self.editPlan.descripcion
                    parsePlan!["fecha"] = self.editPlan.date
                    
                    
                    parsePlan!["imagen"] = self.editPlan.image
                    
                    parsePlan!["lugar"] = self.editPlan.geoPoint
                    parsePlan!["direccion"] = marker.title
                    
                    parsePlan!.saveInBackground()
                    self.actIndicator.stopAnimating()
                } else {
                    print(error)
                }
            }
            
            let parseLugares = PFObject(className: "Lugares")
            parseLugares["nombre"] = marker.title
            parseLugares["direccion"] = marker.title
            parseLugares["ubicacion"] = self.editPlan.geoPoint
            
            parseLugares.saveInBackground()
            
            
            self.performSegueWithIdentifier("guardar", sender: self)
            
            
            
        })
        let actionNo:UIAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionNo)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return true
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
    
}