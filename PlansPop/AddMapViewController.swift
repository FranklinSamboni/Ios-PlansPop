//
//  AddMapViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/11/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class AddMapViewController: UIViewController, GMSMapViewDelegate {
    
    var toPlan = Plan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(2.462362,
            longitude: -76.589704, zoom: 12)
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
        
        // Do any additional setup after loading the view.
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
        let alert:UIAlertController = UIAlertController(title: "Marcar Lugar", message: "¿Quiere elegir este lugar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let actionOK:UIAlertAction = UIAlertAction(title: "SI", style: UIAlertActionStyle.Default, handler: {(UIAlertAction)-> Void in
            
            self.toPlan.geoPoint.latitude = marker.position.latitude
            self.toPlan.geoPoint.longitude = marker.position.longitude
            
            let parsePlan = PFObject(className: "Plan")
            parsePlan["nombre"] = self.toPlan.title
            parsePlan["descripcion"] = self.toPlan.descripcion
            parsePlan["fecha"] = self.toPlan.date
            
            let currentUser = PFUser.currentUser()
            parsePlan["id_user"] = currentUser
            
            parsePlan["imagen"] = self.toPlan.image
            
            parsePlan["lugar"] = self.toPlan.geoPoint
            parsePlan["direccion"] = marker.title
            
            
            let parseLugares = PFObject(className: "Lugares")
            parseLugares["nombre"] = marker.title
            parseLugares["direccion"] = marker.title
            parseLugares["ubicacion"] = self.toPlan.geoPoint
            
            parseLugares.saveInBackground()
            
            parsePlan.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.performSegueWithIdentifier("ir_planes", sender: self)
                } else {
                }
            }
            
            
            
        })
        let actionNo:UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionNo)
        
        self.presentViewController(alert, animated: true, completion: nil)
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    //  }
    
    
}
