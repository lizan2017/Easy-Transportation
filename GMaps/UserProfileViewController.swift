//
//  UserProfileViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/7/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import ObjectMapper

class UserProfileViewController: UIViewController{
    
    let picker = UIImagePickerController()
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var hamburgerMenu: UIBarButtonItem!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userProfileTableView: UITableView!
    
    var userDic:[String:Any] = [:]

    var userDataArray = [String]()
    var currentUser:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = true
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Do any additional setup after loading the view.
        self.userProfileImageView.layer.borderColor = UIColor.white.cgColor
        self.userProfileImageView.layer.borderWidth = 1.0
        self.userProfileImageView.layer.cornerRadius = 65.0
        
        if revealViewController() != nil{
            hamburgerMenu.target = self.revealViewController()
            hamburgerMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        userProfileTableView.delegate = self
        userProfileTableView.dataSource = self
        userProfileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewImagePicker))
        userProfileImageView.addGestureRecognizer(tapGesture)
        self.fetchUserData()
       
    }
    
    func viewImagePicker(){
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    func fetchUserData(){
        self.showProgressHud()
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {
            (snapshot) in
            self.userDataArray = []
            var userData = snapshot.value as! [String:Any]
            userData["Id"] = (FIRAuth.auth()?.currentUser?.uid)!
            self.currentUser = Mapper<User>().map(JSON: userData)
            let imageURL = URL(string: self.currentUser!.imageUrl!)
            self.fullNameLabel.text = self.currentUser!.fullName!
            self.userProfileImageView.sd_setImage(with: imageURL)
            self.userDataArray.append(self.currentUser!.email!)
            self.userDataArray.append(self.currentUser!.fullName!)
            self.userProfileTableView.reloadData()
            self.dismissProgressHud()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserProfileViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserProfileCell
        let tableLabelDetailArray = ["Email", "Full Name"]
        cell.keyLabel.text = tableLabelDetailArray[indexPath.row]
        cell.userDataLabel.text = userDataArray[indexPath.row]
        return cell
    }
}


extension UserProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserProfileCell
        if cell.keyLabel.text! == "Email"{
        var alert = UIAlertController(title: "Edit", message: "Edit your \(cell.keyLabel.text!) below", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style:.default, handler: {
            _ in
            self.showProgressHud()
            let emailTextField = alert.textFields![0] as UITextField
            ProfileController().updateUserEmail(userEmail: emailTextField.text!, UID: self.currentUser!.id!, completion: {
                (result) in
                if result == true{
                    self.dismissProgressHud()
                    alert = UIAlertController(title: "Sign Out", message: "Signing Out!!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
                        _ in
                       try? FIRAuth.auth()?.signOut()
                        ProfileController().logout(completion: {
                            (result) in
                            if result == true{
                                Router().pushLoginViewController(source: self, email: self.currentUser!.email!)
                            }
                        })
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        })
            
        alert.addTextField(configurationHandler: {
            (textfield: UITextField) in
            textfield.placeholder = "Enter your new Email ID"
        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
            
        }else if cell.keyLabel.text! == "Full Name"{
            
            var alert = UIAlertController(title: "Edit", message: "Edit your \(cell.keyLabel.text!) below", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style:.default, handler: {
                _ in
                self.showProgressHud()
                let fullNameTextField = alert.textFields![0] as UITextField
                ProfileController().updateUserName(userName: fullNameTextField.text!, UID: self.currentUser!.id!, completion: {
                    (result) in
                    if result == true{
                        self.dismissProgressHud()
                        alert = UIAlertController(title: "Sucess", message: "Name Updated sucessfully!!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                })
            })
            alert.addTextField(configurationHandler: {
                (textfield:UITextField) in
                textfield.placeholder = "Update your name"
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            let imageData = UIImagePNGRepresentation(selectedImage)
            self.showProgressHud()
            ProfileController().updateProfileImage(userName: currentUser!.fullName!, image: imageData!, UID: currentUser!.id! , completion: {
                (result) in
                if result == true{
                    self.dismissProgressHud()
                    let alert = UIAlertController(title: "Sucess", message: "Image updated sucessfully!", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
                        _ in
                        self.userProfileImageView.image = selectedImage
                    })
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}
