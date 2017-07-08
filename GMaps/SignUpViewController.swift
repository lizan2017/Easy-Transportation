//
//  SignUpViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/9/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var createAccBtn: UIButton!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    var storageRef:FIRStorageReference!
    var databaseRef:FIRDatabaseReference!
    var databaseHandle:FIRDatabaseHandle!
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.uploadImageView.layer.cornerRadius = 50.0
        self.backBtn.layer.cornerRadius = 20.0
        self.createAccBtn.layer.cornerRadius = 20.0
        self.backBtn.layer.borderColor = UIColor.white.cgColor
        self.backBtn.layer.borderWidth = 1.0
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadUserImage)))
        uploadImageView.isUserInteractionEnabled = true
       
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    
    func uploadUserImage(){
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker:UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
        
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToLogin(_ sender: Any) {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginVC, animated: true, completion: nil)
        
    }
    

    @IBAction func creatingAccount(_ sender: Any) {
        createUser()
    }
    
    func createUser(){
        if emailTextField.text != "" && passwordTextField.text != ""{
            self.showProgressHud()
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            
            if user != nil{
                if self.uploadImageView.image != nil{
                    
                self.databaseRef = FIRDatabase.database().reference()
                
                if let uploadData = UIImagePNGRepresentation(self.uploadImageView.image!){
                
                self.storageRef = FIRStorage.storage().reference().child(self.nameTextField.text!).child("image.png")
                    self.storageRef.put(uploadData, metadata: nil, completion: {
                        (metadata, error) in
                        
                self.databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Full Name").setValue(self.nameTextField.text)
                    
                    self.databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Email").setValue(self.emailTextField.text)
                        
                    self.databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("ImageUrl").setValue(String(describing: (metadata?.downloadURL())!))
                        self.dismissProgressHud()
                    let sb = UIStoryboard(name: "Login", bundle: nil)
                        let loginVC = sb.instantiateViewController(withIdentifier: "loginVC")
                        self.present(loginVC, animated: true, completion: nil)
                    })
                
                }
                }else{
                    self.dismissProgressHud()
                    let alert = UIAlertController(title: "Error", message: "Please Upload your profile image!!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else{
                self.dismissProgressHud()
                let alert = UIAlertController(title: "Error", message: "Error Creating User!!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
        }else{
            self.dismissProgressHud()
            let alert = UIAlertController(title: "Error", message: "Please enter valid email or password!!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}
