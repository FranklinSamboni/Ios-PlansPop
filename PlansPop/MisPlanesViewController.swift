import UIKit
import Parse

class MisPlanesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var data = [Plan]()
    var parti:Int32 = 0
    var cont:Int = 1
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = false
        
        self.tableView.addSubview(self.refreshControl)
        
            super.viewDidLoad()
            actIndicator.hidesWhenStopped = true
            //loadData()
    }
   
    
    func loadData() {
        tableView.hidden = true
        actIndicator.startAnimating()
        let user = PFUser.currentUser()
        print(user!.username)
        
        let query = PFQuery(className: "Plan")
        query.whereKey("id_user", equalTo:user!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Success")
                print(objects?.count)
                
                if let objects = objects {
                    for object in objects{
                        var plan = Plan(title: object.objectForKey("nombre") as! String, descripcion: object.objectForKey("descripcion") as! String, date: object.objectForKey("fecha") as! String, place: object.objectForKey("direccion") as! String, image: object.objectForKey("imagen") as! PFFile, assist: self.parti)
                        plan.id_Plan = object.objectId
                        plan.geoPoint = object.objectForKey("lugar") as! PFGeoPoint
                        self.data.append(plan)
                        
                    }
                }
                
            }else{
                print("Error: \(error!) \(error!.userInfo)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                
            })
            
        }

    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        data.removeAll()
        loadData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("celda")
        
        if cell == nil {
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "celda")
        }
        cell?.textLabel?.text = "Hola"*/
        let cell: CellsTableViewCell = tableView.dequeueReusableCellWithIdentifier("celda") as! CellsTableViewCell
        
        let pos = indexPath.row
        
        cell.title.text = data[pos].title
        cell.desc.text = data[pos].descripcion
        /*cell.place.text = data[pos].place
        var fecha_c = [String]()
        fecha_c = data[pos].date.componentsSeparatedByString(" ")
        cell.date.text = fecha_c[0]
        cell.hour.text = fecha_c[1] + fecha_c[2]
        print(cell.hour.text)*/
        let userImageFile = data[pos].image as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let images = UIImage(data:imageData)
                    cell.img.image = images
                }
            }
        }
        
        //print("asistentes")
        //print(data[pos].assist)
        //cell.assist.text = String(data[pos].assist)
        actIndicator.stopAnimating()
        tableView.hidden = false
        print("cargo items")
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.data.count)
        return data.count
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        self.data.removeAll()
        self.performSegueWithIdentifier("log_out", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "editar_mis_planes":
                let DvController = segue.destinationViewController as! EditPlanViewController
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell){
                    DvController.plan = data[indexPath.row]
                }
                
            default: break
                
            }
        }
    }
    // MARK - Pull to fresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        data.removeAll()
        self.loadData()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    
}
