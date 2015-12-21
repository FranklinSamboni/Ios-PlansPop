import UIKit
import Parse
import SQLite

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var search_bar: UISearchBar!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
  
    var data = [Plan]()
    var parti:Int32 = 0
    var search = [Plan]()
    var num_planes:Int = 0
    var aux:Int = 0    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = false
        
        self.tableView.addSubview(self.refreshControl)
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            super.viewDidLoad()
            search_bar.delegate = self
            actIndicator.hidesWhenStopped = true
            
        }else{
            self.performSegueWithIdentifier("log_out", sender: self)
        }
    }
    
    // MARK - Load Data
    func load_data (){
        self.tableView.hidden = true
        self.actIndicator.startAnimating()
        let query = PFQuery(className: "Plan")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Success")
                print(objects?.count)
                self.num_planes = (objects?.count)!
                
                if let objects = objects {
                    for object in objects{
                        
                        var plan = Plan(title: object.objectForKey("nombre") as! String, descripcion: object.objectForKey("descripcion") as! String, date: object.objectForKey("fecha") as! String, place: object.objectForKey("direccion") as! String, image: object.objectForKey("imagen") as! PFFile, assist: self.parti)
                        plan.id_Plan = object.objectId
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
        self.aux = 0
        data.removeAll()
        load_data()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Load Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CellsTableViewCell = tableView.dequeueReusableCellWithIdentifier("celda") as! CellsTableViewCell
        
        let pos = indexPath.row
        
        if self.aux == 0 {
        cell.title.text = data[pos].title
        cell.desc.text = data[pos].descripcion
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
        }else{
            cell.title.text = search[pos].title
            cell.desc.text = search[pos].descripcion
            if search[pos].image != nil {
            let userImageFile = search[pos].image as PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let images = UIImage(data:imageData)
                        cell.img.image = images
                    }
                }
            }
         }
        }
        self.actIndicator.stopAnimating()
        self.tableView.hidden = false
        print("cargo items")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.data.count)
        if self.aux == 0 {
            return data.count
        }else{
            return search.count
        }
    }

    // MARK - Cerrar sesion
    @IBAction func log_out(sender: AnyObject) {
        PFUser.logOut()
        data.removeAll()
        search.removeAll()
        self.performSegueWithIdentifier("log_out", sender: self)
        
    }
    
    // MARK - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            
            case "details":
                let DvController = segue.destinationViewController as! DetailsViewController
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell){
                    DvController.plan = data[indexPath.row]
                }
            default: break
            }
        }
    }
    
    // MARK - Search Bar
    @IBAction func search_action(sender: AnyObject) {
        
        if search_bar.hidden {
            search_bar.hidden = false
            search_bar.becomeFirstResponder()
        }else{
            search_bar.hidden = true
            self.aux = 0
            data.removeAll()
            load_data()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        search_bar.hidden = true
        self.aux = 0
        data.removeAll()
        load_data()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let text = NSString(string: searchBar.text!)
        let text_e = text as String
        self.search.removeAll()
        self.aux = 1
        print(text)
        if (text_e.isEmpty == true) {
            self.aux = 0
            data.removeAll()
            load_data()
        }else{
        
        for var i = 0; i < data.count; i++ {
            print(i)
            print(data[i].title)
            
            if self.data[i].title.lowercaseString.hasPrefix(text as String){
                self.search.append(data[i])
            }
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        
    }
    
    // MARK - Pull to fresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        self.aux = 0
        data.removeAll()
        load_data()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

