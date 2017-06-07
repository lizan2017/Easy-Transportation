//
//  UserProfileViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/7/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userProfileImageView.layer.borderColor = UIColor.white.cgColor
        self.userProfileImageView.layer.borderWidth = 1.0
            self.userProfileImageView.layer.cornerRadius = 65.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
