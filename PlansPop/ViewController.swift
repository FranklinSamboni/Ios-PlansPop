//
//  ViewController.swift
//  PlansPop
//
//  Created by Aplimovil on 12/8/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    
    
    
  
    var data = [Plan]()
    var parti:Int32 = 0
    var cont:Int = 1
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = false
        //self.view_cell.layer.borderWidth = 1
        
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            super.viewDidLoad()
        
        let user = PFUser.currentUser()
           print(user!.username)
        
        let query = PFQuery(className: "Plan")
            
            query.findObjectsInBackgroundWithBlock{(objects: [PFObject]?, error: NSError?) -> Void in
            
                if error == nil {
                print("Success")
                print(objects?.count)
                    
                    if let objects = objects {
                        for object in objects{
                            
                            /*let relation = object.relationForKey("Asistentes")
                            let assist = relation.query()
                            assist.countObjectsInBackgroundWithBlock {
                                (count: Int32, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    self.parti = count
                                    print("Particpantes")
                                    print(self.parti)
                                                                    }
                                /*let plan = Plan(title: object.objectForKey("nombre") as! String, descripcion: object.objectForKey("descripcion") as! String, date: object.objectForKey("fecha") as! String, place: object.objectForKey("direccion") as! String, image: object.objectForKey("imagen") as! PFFile, assist: self.parti)
                                
                                self.data.append(plan)
                                var cont:Int = 1
                                cont = cont + 1
                                print(objects.count)
                                print(cont)*/
                            }
                            */

                           let plan = Plan(title: object.objectForKey("nombre") as! String, descripcion: object.objectForKey("descripcion") as! String, date: object.objectForKey("fecha") as! String, place: object.objectForKey("direccion") as! String, image: object.objectForKey("imagen") as! PFFile, assist: self.parti)
                            
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
            
            
        }else{
            self.performSegueWithIdentifier("log_out", sender: self)
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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
        
        print("cargo items")
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.data.count)
        return data.count
    }


    @IBAction func log_out(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("log_out", sender: self)
        
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
    
    

}

