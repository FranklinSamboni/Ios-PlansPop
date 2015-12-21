//
//  AssistViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/9/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse


class AssistViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    var planDao:PlanDao!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var data = [Plan]()
    var parti:Int32 = 0
    var cont:Int = 1
    var data2 = [Plan]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true
        self.tableView.addSubview(self.refreshControl)
        self.navigationController?.navigationBarHidden = false
        planDao = PlanDao()
        //loadData()
        //self.view_cell.layer.borderWidth = 1
    }
    
    func loadData() {
        tableView.hidden = true
        actIndicator.startAnimating()
        
        let currentUser = PFUser.currentUser()
        let query = PFQuery(className: "Plan")
        query.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Success")
                print(objects?.count)
                
                if let objects = objects {
                    for object in objects{
                        
                        let relation = object.relationForKey("Asistentes") as PFRelation
                        let qry = relation.query()
                        qry.findObjectsInBackgroundWithBlock{(objs: [PFObject]?, er: NSError?)->Void in
                            
                            if(er == nil){
                                
                                print(objs?.count)
                                if let objs = objs {
                                    for obj in objs{
                                        
                                        print(currentUser!.objectId! + " " + obj.objectId!)
                                        if currentUser!.objectId == obj.objectId{
                                            
                                            var plan = Plan(title: object.objectForKey("nombre") as! String, descripcion: object.objectForKey("descripcion") as! String, date: object.objectForKey("fecha") as! String, place: object.objectForKey("direccion") as! String, image: object.objectForKey("imagen") as! PFFile, assist: self.parti)
                                            plan.id_Plan = object.objectId
                                            
                                            self.data.append(plan)
                                            self.data2 = self.planDao.getAll()
                                            if self.data2.count == 0  {
                                                self.planDao.insert(plan)
                                            }else{
                                            
                                            for db_plan in self.data2 {
                                                if db_plan.id_Plan == plan.id_Plan {
                                                   self.planDao.update(plan)
                                                }else{
                                                    self.planDao.insert(plan)
                                                }
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                            else{
                                print("no")
                                
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                                
                            })
                            
                        }
                        
                    }
                }
                
                
                
                
            }
            
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
        
        let cell: CellsTableViewCell = tableView.dequeueReusableCellWithIdentifier("celda") as! CellsTableViewCell
        
        let pos = indexPath.row
        
        data2 = self.planDao.getAll()
        
        cell.title.text = data2[pos].title
        cell.desc.text = data2[pos].descripcion
        cell.place.text = data2[pos].place
        //cell.title.text = data[pos].title
        //cell.desc.text = data[pos].descripcion
        //cell.place.text = data[pos].place
        var fecha_c = [String]()
        fecha_c = data2[pos].date.componentsSeparatedByString(" ")
        //fecha_c = data[pos].date.componentsSeparatedByString(" ")
        cell.date.text = fecha_c[0]
        cell.hour.text = fecha_c[1] + fecha_c[2]
        print(cell.hour.text)
        
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
        
        print("cargo items")
        actIndicator.stopAnimating()
        tableView.hidden = false
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.data.count)
        return data.count
    }
    
    
    @IBAction func log_out(sender: AnyObject) {
        PFUser.logOut()
        data.removeAll()
        self.performSegueWithIdentifier("log_out_assist", sender: self)
        
    }
    
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
    // MARK - Pull to fresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        data.removeAll()
        loadData()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
}
