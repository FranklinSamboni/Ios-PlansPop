import UIKit
import Parse

class RememberViewController: UIViewController {
    
    @IBOutlet var email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Send_email
    @IBAction func send_email(sender: AnyObject) {
        
        let email_t = email.text
        
        if (email_t?.utf16.count == 0){
            
            let alert:UIAlertController = UIAlertController(title: "Invalid", message: "Please, Insert a email address.", preferredStyle: UIAlertControllerStyle.Alert)
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
                    
                    print("Email no existe")
                    let alert:UIAlertController = UIAlertController(title: "Invalid", message: "The email address \(email_t!) isn`t registered.", preferredStyle: UIAlertControllerStyle.Alert)
                    let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(actionOK)
                    presentViewController(alert, animated: true, completion: nil)

                    
                }else{
                
                    PFUser.requestPasswordResetForEmailInBackground(email.text!)
                    print("Email enviado")
                    let alert:UIAlertController = UIAlertController(title: "Success", message: "Send the restoration link to email address \(email.text!).", preferredStyle: UIAlertControllerStyle.Alert)
                    let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                        self.performSegueWithIdentifier("login_rem", sender: nil)
                    }
                    alert.addAction(actionOK)
                    presentViewController(alert, animated: true, completion: nil)
                    
                }
            }catch{
                
            }
        }else{
            print("Email incorrecto")
            let alert:UIAlertController = UIAlertController(title: "Invalid", message: "Please, Insert a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
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

}
