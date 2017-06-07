//
//  SideMenuViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit


class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var dataSource = ["Map View","Saved Location", "Bus Stops","Profile", "Log Out"]
 
    
    @IBOutlet weak var savedLocTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smCell") as! SideMenuCell
       
        cell.menuItemLabel.text = dataSource[indexPath.row]
        cell.menuItemLabel.layer.cornerRadius = 15.0
        cell.contentView.backgroundColor = UIColor.black
        if cell.menuItemLabel.text == "Log Out"{
            cell.menuItemLabel.backgroundColor = UIColor.red
            cell.menuItemLabel.textColor = UIColor.white
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SideMenuCell
        cell.isHighlighted = false
        cell.isSelected = false
        if cell.menuItemLabel.text == "Bus Stops"{
            let sb = self.storyboard
            let stopLocationVC = sb?.instantiateViewController(withIdentifier: "bsvc")
            let nav = UINavigationController(rootViewController: stopLocationVC!)
            self.revealViewController().pushFrontViewController(nav, animated: true)

            
        }
        
        if cell.menuItemLabel.text == "Saved Location"{
        let sb = self.storyboard
        let savedLocationVC = sb?.instantiateViewController(withIdentifier: "slvc")
        let nav = UINavigationController(rootViewController: savedLocationVC!)
        self.revealViewController().pushFrontViewController(nav, animated: true)
        }
        if cell.menuItemLabel.text == "Profile"{
            let sb = UIStoryboard(name: "UserProfile", bundle: nil)
            let userProfileVC = sb.instantiateViewController(withIdentifier: "userProfile")
            self.revealViewController().pushFrontViewController(userProfileVC, animated: true)
        }
        if cell.menuItemLabel.text == "Map View"{
            self.revealViewController().bounceBackOnLeftOverdraw = true
            let sb = self.storyboard
            let mapView = sb?.instantiateViewController(withIdentifier: "mapVC")
            let nav = UINavigationController.init(rootViewController: mapView!)
            self.revealViewController().pushFrontViewController(nav, animated: true)

        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
