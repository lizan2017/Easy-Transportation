//
//  BusStopsViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import GoogleMaps

class BusStopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,CLLocationManagerDelegate {

    @IBOutlet weak var busStopsTableView: UITableView!
    var busStopsArray:Array<[String:Any]> = []
    var busStopDictionary:[String:Any] = [:]
    var fetchedArray:Array<[String:Any]> = []
    var fetchedDictionary:[String:Any] = [:]
    var locationManager :CLLocationManager!
    var currentLocation:CLLocation?
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftbutton = UIBarButtonItem(image: UIImage(named: "h6"), style: .plain, target: self, action: #selector(toggleSideMenu))
        self.navigationItem.leftBarButtonItem = leftbutton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        
        busStopsTableView.delegate = self
        busStopsTableView.dataSource = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
       
        self.title = "Bus Stops"
        
        
        
        // Do any additional setup after loading the view.
    }

    func toggleSideMenu() {
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do{
            let busData = try! context.fetch(BusStops.fetchRequest())
            if busData.count != 0{
            for i:Int in 0 ..< busData.count{
                let busStopData = busData[i] as! BusStops
                context.delete(busStopData)
                try! context.save()
            }
            }else{
                return
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

      
        let location = locations.last
        
        
        
        
        if counter == 0 {
            currentLocation = location
            if busStopsArray.count == 0 {
                self.busStops()
            }
        }
        locationManager.stopUpdatingLocation()
        counter = counter + 1
    }
    
    
    func busStops(){
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)&key=AIzaSyCxPL3sLGcSrreEbETzkUXrMT3Cq0ywejA&rankby=distance&types=bus_station"
        
        Alamofire.request(url).responseJSON {(response) in
            let bustopDic = response.result.value as! [String:Any]
            let resultArray = bustopDic["results"] as! Array<[String:Any]>
            for i:Int in 0 ..< resultArray.count{
                let busDic = resultArray[i]
                
                let busLocation = busDic["geometry"] as! [String:Any]
                let busCoordinate = busLocation["location"] as! [String:Any]
                let busName = busDic["name"] as! String
                self.busStopDictionary["name"] = busName
                self.busStopDictionary["lat"] = busCoordinate["lat"]
                self.busStopDictionary["lon"] = busCoordinate["lng"]
                self.busStopsArray.append(self.busStopDictionary)
                
                
            }
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            
            for i:Int in 0 ..< self.busStopsArray.count{
                let busEntity = BusStops(context: context)
                let busDetail = self.busStopsArray[i]
                busEntity.name = busDetail["name"] as? String
                busEntity.lat = String(describing: busDetail["lat"]!)
                busEntity.lon = String(describing: busDetail["lon"]!)
                do{
                    try! context.save()
                    
                }
                
            }
            self.fetchBusStopData()
            
            
            
        }
        
    }
    
    func fetchBusStopData(){
        self.showProgressHud()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do{
            let busData = try! context.fetch(BusStops.fetchRequest())
            
            for i:Int in 0 ..< busData.count{
                let busStopData = busData[i] as! BusStops
                self.fetchedDictionary["name"] = busStopData.name
                self.fetchedDictionary["latitude"] = busStopData.lat
                self.fetchedDictionary["longitude"] = busStopData.lon
                self.fetchedArray.append(self.fetchedDictionary)
                
            }
            self.dismissProgressHud()
            busStopsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busStopcell") as! BusStopsTableViewCell
        let busStopDic = fetchedArray[indexPath.row]
        cell.busStopCellView.layer.cornerRadius = 10.0
        cell.contentView.backgroundColor = UIColor.lightGray
        cell.busStopNameLabel.text = busStopDic["name"]! as? String
        cell.busStopLatLabel.text = String(describing: busStopDic["latitude"]!)
        cell.busStopLonLabel.text = String(describing: busStopDic["longitude"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BusStopsTableViewCell
        let sb = self.storyboard
        let mapView = sb?.instantiateViewController(withIdentifier: "smvc") as! SavedMapViewController
        mapView.titleString = cell.busStopNameLabel.text!
        mapView.latiString = cell.busStopLatLabel.text!
        mapView.longiString = cell.busStopLonLabel.text!
        self.navigationController?.pushViewController(mapView, animated: true)
    }

}
