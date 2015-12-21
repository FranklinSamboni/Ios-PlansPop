import UIKit
import Parse

class Register_2ViewController: UIViewController {

    @IBOutlet var birthd: UITextField!
    @IBOutlet var selection_sex: UISegmentedControl!
    @IBOutlet var completename: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var c_password: UITextField!
    var email_r: String = ""
    var sex:String = "Mujer"
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    @IBOutlet var Register_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - DatePicker    
    @IBAction func edit_birthdate(sender: AnyObject) {
        DatePickerDialog().show("BirthDate", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            var fecha_c = [String]()
            let date = String(date)
            fecha_c = date.componentsSeparatedByString(" ")
            self.birthd.text = fecha_c[0]
        }
    }
    
    // MARK: - Selection Sex
    @IBAction func change_sex(sender: AnyObject) {
        
        switch selection_sex.selectedSegmentIndex {
        case 0:
            sex = "Mujer"
        case 1:
            sex = "Hombre"
        default:
            break        
        }
        print(sex)
    }
    
    // MARK: - Register
    @IBAction func Register(sender: AnyObject) {
        
        actIndicator.startAnimating()
        Register_button.hidden = true
        
        let c_name = completename.text
        let birth = birthd.text
        let user = username.text
        let pass = password.text
        let c_pass = c_password.text
        
        if (c_name?.utf16.count == 0 || birth?.utf16.count == 0 || user?.utf16.count == 0 || pass?.utf16.count == 0 || c_pass?.utf16.count == 0){
            
            print("Campos vacios")
            let alert:UIAlertController = UIAlertController(title: "Warning", message: "Please fill all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(actionOK)
            actIndicator.stopAnimating()
            Register_button.hidden = false
            presentViewController(alert, animated: true, completion: nil)
        
        }else if (pass?.utf16.count < 4){
            
                print("Contraseñas cortas")
                let alert:UIAlertController = UIAlertController(title: "Warning", message: "Password must be greater then 4.", preferredStyle: UIAlertControllerStyle.Alert)
                let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                    self.password.text = ""
                    self.c_password.text = ""
                    self.password.becomeFirstResponder()
                }
                alert.addAction(actionOK)
                actIndicator.stopAnimating()
                Register_button.hidden = false
                presentViewController(alert, animated: true, completion: nil)
            
        }else if ( pass != c_pass ){
                print("Contraseñas diferentes")
                let alert:UIAlertController = UIAlertController(title: "Warning", message: "Password must match.", preferredStyle: UIAlertControllerStyle.Alert)
                let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                    self.password.text = ""
                    self.c_password.text = ""
                    self.password.becomeFirstResponder()
                }
                alert.addAction(actionOK)
                actIndicator.stopAnimating()
                Register_button.hidden = false
                presentViewController(alert, animated: true, completion: nil)
            }else{
            
            let user = PFUser()
            
            user.username = self.username.text
            user.password = self.password.text
            user.email = self.email_r
            user["name"] = self.completename.text
            user["sex"] = self.sex
            user["b_date"] = self.birthd.text
            
            
            user.signUpInBackgroundWithBlock{(succeeded: Bool, error: NSError?) -> Void in
            
                if let error = error {
                
                    let errorString = error.userInfo["error"] as? NSString
                    var error = [String]()
                    error = (errorString?.componentsSeparatedByString(" "))!
                    if error[0] == "username" {
                        print("Error en registro for username")
                        let alert:UIAlertController = UIAlertController(title: "Error!", message: String(errorString!) , preferredStyle: UIAlertControllerStyle.Alert)
                        let actionOK:UIAlertAction = UIAlertAction(title: "Change", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                            self.username.text = ""
                            self.username.becomeFirstResponder()
                        }
                        alert.addAction(actionOK)
                        self.actIndicator.stopAnimating()
                        self.Register_button.hidden = false
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        print("Error en registro")
                        let alert:UIAlertController = UIAlertController(title: "Error", message: "I didn`t register, Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                        let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        alert.addAction(actionOK)
                        self.actIndicator.stopAnimating()
                        self.Register_button.hidden = false
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }else{
                    self.actIndicator.stopAnimating()
                    
                    self.performSegueWithIdentifier("register_ok", sender: self)
                }
            }
        }
    }
}

