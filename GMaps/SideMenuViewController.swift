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
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var savedLocTableview: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var weatherRefreshBtn: UIImageView!
    @IBOutlet weak var userImageview: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cityWeatherLabel: UILabel!
    @IBOutlet weak var countryWeatherLabel: UILabel!
    @IBOutlet weak var statusWeatherLabel: UILabel!
    @IBOutlet weak var degreesWeatherLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        userImageview.layer.cornerRadius = 20
        userNameLabel.textColor = UIColor.white
        weatherRefreshBtn.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getWeatherData))
        weatherRefreshBtn.addGestureRecognizer(tapGesture)
        weatherRefreshBtn.isUserInteractionEnabled = true
        indicator.hidesWhenStopped = true
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
        indicator.startAnimating()
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(String(describing: (currentLocation?.coordinate.latitude)!))&lon=\(String(describing: (currentLocation?.coordinate.longitude)!))&units=metric&APPID=1ba68cb538a3781224d196cb3d0aa9ea"
        
       Alamofire.request(url).responseJSON(completionHandler: {(response) in
            
            let weatherData = response.value as! [String:Any]
            let sysInfo = weatherData["sys"] as! [String:Any]
            let weatherCountry = sysInfo["country"] as! String
            let mainVar = weatherData["main"] as! [String:Any]
            let currentTemp = mainVar["temp"]
            let cityName = weatherData["name"] as! String
            let weatherInfoArray = weatherData["weather"] as! Array<[String:Any]>
            let weatherInfo = weatherInfoArray[0]
            let weatherStatus = weatherInfo["main"] as! String
            self.indicator.stopAnimating()
        
            self.cityWeatherLabel.text = cityName
            self.countryWeatherLabel.text = weatherCountry
            self.degreesWeatherLabel.text = "\(String(describing: currentTemp!)) °C"
            self.statusWeatherLabel.text = weatherStatus
            if weatherStatus == "Rain"{
                self.weatherImageView.image = UIImage(named: "rain")
                }else if weatherStatus == "Clouds"{
                self.weatherImageView.image = UIImage(named: "cloudy")
            }else if weatherStatus == "Clear"{
                self.weatherImageView.image = UIImage(named: "sunny")
            }else if weatherStatus == "Haze"{
                self.weatherImageView.image = UIImage(named: "haze")
            }else{
                return
        }
       }
        )
    
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
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let stopLocationVC = sb.instantiateViewController(withIdentifier: "bsvc")
            let nav = UINavigationController(rootViewController: stopLocationVC)
            self.revealViewController().pushFrontViewController(nav, animated: true)

            
        }
        
        if cell.menuItemLabel.text == "Saved Location"{
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let savedLocationVC = sb.instantiateViewController(withIdentifier: "slvc")
        let nav = UINavigationController(rootViewController: savedLocationVC)
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
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let mapView = sb.instantiateViewController(withIdentifier: "mapVC")
            let nav = UINavigationController.init(rootViewController: mapView)
            self.revealViewController().pushFrontViewController(nav, animated: true)

        
        }
        if cell.menuItemLabel.text == "Log Out"{
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {
                _ in
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
            })
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            alert.addAction(cancelAlert)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
