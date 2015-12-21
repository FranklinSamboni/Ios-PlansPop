import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet var email: UITextField!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check Email
    @IBAction func next_check_email(sender: AnyObject) {
        
        let email_t = email.text
        
        if (email_t?.utf16.count == 0){
        
            let alert:UIAlertController = UIAlertController(title: "Warnning", message: "Please fill out the field.", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(actionOK)
            presentViewController(alert, animated: true, completion: nil)
            
        }else if (validate(email.text!) == true){
            
                print("correcto email")
                let query = PFUser.query()
                query?.whereKey("email", equalTo: email.text!)
            
                do{
                    let equals = try query?.findObjects()
                    let cont = equals?.count
                
                    if cont == 0 {
                    
                        self.performSegueWithIdentifier("register_2", sender: self)
                
                    }else{
                    
                        print("Email existe")
                        let alert:UIAlertController = UIAlertController(title: "Invalid", message: "The email address \(email_t!) already registered.", preferredStyle: UIAlertControllerStyle.Alert)
                        let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                            self.email.text = ""
                            self.email.becomeFirstResponder()
                        }
                        alert.addAction(actionOK)
                        presentViewController(alert, animated: true, completion: nil)
                    }
                }catch{
            
                }
        }else{
            print("Email incorrecto")
            let alert:UIAlertController = UIAlertController(title: "Invalid", message: "Please, Insert a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                self.email.text = ""
                self.email.becomeFirstResponder()
            }
            alert.addAction(actionOK)
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Validate Email
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(YourEMailAddress)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "register_2":
                let R_2Controller = segue.destinationViewController as! Register_2ViewController
                R_2Controller.email_r = self.email.text!
                
            default: break
                
            }
        }
    }
    // MARK: - Cancel Register
    @IBAction func Cancel_Register(sender: AnyObject) {
        let alert:UIAlertController = UIAlertController(title: "Warnning", message: "Sure , you want to log out Pop Plans.", preferredStyle: UIAlertControllerStyle.Alert)
        let actionOK:UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
            self.performSegueWithIdentifier("cancel_register", sender: self)
        }
        let actionCancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        presentViewController(alert, animated: true, completion: nil)
    }

}
