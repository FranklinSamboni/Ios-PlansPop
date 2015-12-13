//
//  MapViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/9/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.cameraWithLatitude(2.462362,
            longitude: -76.589704, zoom: 12)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
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
        
        /*let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        */
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
