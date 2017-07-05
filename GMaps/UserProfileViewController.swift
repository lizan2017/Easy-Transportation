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

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let picker = UIImagePickerController()
    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var hamburgerMenu: UIBarButtonItem!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var userProfileTableView: UITableView!
    
    var userDic:[String:Any] = [:]
    var userDataArray:Array<[String:Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        
        self.fetchUserData()
        
        
       
    }
    
    func fetchUserData(){
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {
            (snapshot) in
            let userData = snapshot.value as! NSDictionary
            let keys = userData.allKeys as! Array<String>
            let values = userData.allValues as! Array<String>
            for i:Int in 0 ..< keys.count{
                self.userDic[keys[i]] = values[i]
                
                
            }

            let url = userData["ImageUrl"] as! String
            let imageURL = URL(string: url)
            self.fullNameLabel.text = userData["Full Name"] as? String
            self.userProfileImageView.sd_setImage(with: imageURL)
            self.userProfileTableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (userDic.count - 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserProfileCell
        
        let userProfileDic = userDic as NSDictionary
        var keysDic = userProfileDic.allKeys as! Array<String>
        var valuesDic = userProfileDic.allValues as! Array<String>
        if keysDic[indexPath.row] == "ImageUrl"{
            keysDic.remove(at: 0)
            valuesDic.remove(at: 0)
        }
        cell.keyLabel.text = keysDic[indexPath.row]
        cell.userDataLabel.text = valuesDic[indexPath.row]
        
        
        
       return cell
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
            
            userProfileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}
