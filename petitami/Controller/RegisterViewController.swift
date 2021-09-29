//
//  RegisterViewController.swift
//  petitami
//
//  Created by Marcelo Simim on 28/09/21.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = passwordConfirmTextField.text ?? ""
        
        if Validation.notEmptyField(email) && Validation.notEmptyField(password) && Validation.notEmptyField(name){
            if Validation.matchField(password, confirmPassword){
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        self.alert(title: "Error", message: e.localizedDescription)
                    }else{
                        FirebaseCollection.userRef.document((authResult?.user.uid)!).setData([K.firebaseName: name,
                                                                                              K.firebaseEmail: email,
                                                                                              K.firebaseUnity: 1,
                                                                                              K.firebaseExercise:1]) { error in
                            
                            if let error = error {
                                self.alert(title: "Error", message: error.localizedDescription)
                            }else{
                                self.performSegue(withIdentifier: K.registerSegue, sender: self)
                            }
                        }
                        
                    }
                }
            }else{
                alert(title: "Error", message: "The confirm password does not match")
            }
        }else{
            alert(title: "Error", message: "All the fields are required")
        }
    }
    
    //MARK: - Alert
    
    func alert(title:String, message:String){
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok:UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
}
