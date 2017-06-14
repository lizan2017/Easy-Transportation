//
//  SideMenuViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import GoogleMaps
import Firebase
import SDWebImage

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , CLLocationManagerDelegate{

    var dataSource = ["Map View","Saved Location", "Bus Stops","Profile", "Log Out"]
    var locationManager :CLLocationManager!
    var currentLocation:CLLocation?
    
    @IBOutlet weak var savedLocTableview: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageview: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        userImageview.layer.cornerRadius = 20
        userNameLabel.textColor = UIColor.white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.getUserDataFromFirebase()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.currentLocation = location
        self.locationManager.stopUpdatingLocation()
        
        self.getWeatherData()
    }
    
    
    func getWeatherData() {
        let url = "api.openweathermap.org/data/2.5/forecast?id=524901&APPID=1ba68cb538a3781224d196cb3d0aa9ea"
        Alamofire.request(url).responseJSON(completionHandler: {(response) in
        
          
        
        })
    }
    
    
    func getUserDataFromFirebase(){
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {
            (snapshot) in
            let userData = snapshot.value as! [String:Any]
            self.userNameLabel.text = userData["Full Name"] as? String
            let url = userData["ImageUrl"] as! String
            let imageUrl = URL(string: url)
//            let data = try? Data(contentsOf: imageUrl!)
//            DispatchQueue.main.async {
//                self.userImageview.image = UIImage(data: data!)
//            }
            self.userImageview.sd_setImage(with: imageUrl)
            
        })
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
            let nav = UINavigationController(rootViewController: userProfileVC)
            self.revealViewController().pushFrontViewController(nav, animated: true)
        }
        if cell.menuItemLabel.text == "Map View"{
            self.revealViewController().bounceBackOnLeftOverdraw = true
            let sb = self.storyboard
            let mapView = sb?.instantiateViewController(withIdentifier: "mapVC")
            let nav = UINavigationController.init(rootViewController: mapView!)
            self.revealViewController().pushFrontViewController(nav, animated: true)

        
        }
        if cell.menuItemLabel.text == "Log Out"{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchedData = try! context.fetch(LoginData.fetchRequest())
            for i:Int in 0 ..< fetchedData.count{
            let emailData = fetchedData[i] as! LoginData
            context.delete(emailData)
                
            try? context.save()
                
                let sb = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = sb.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
          }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
