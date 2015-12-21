import UIKit
import GoogleMaps
import Parse

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(2.462362,
            longitude: -76.599994, zoom: 13)
        
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        
        self.view = mapView
        
        // MARK: - Load GeoPoints
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
                        marker.map = mapView
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
