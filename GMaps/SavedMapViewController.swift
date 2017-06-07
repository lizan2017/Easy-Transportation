//
//  SavedMapViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/17/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
class SavedMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    var currentLocation:CLLocation!
    var locationManager:CLLocationManager!
    var mapView:GMSMapView!
    var titleString:String = ""
    var latiString:String = ""
    var longiString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        self.initGoogleMap()
        // Do any additional setup after loading the view.
    }
    
    func initGoogleMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 27.7172, longitude: 85.3240, zoom: 15)
        let mapRect:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        mapView = GMSMapView.map(withFrame: mapRect, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        view.addSubview(mapView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        currentLocation = location
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15)
        mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        if latiString == ""{
            return
        }else{
            
            self.savedLocation()
        }
    }
    
    func savedLocation(){
        let marker = GMSMarker()
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latiString)!, longitude: CLLocationDegrees(longiString)!, zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latiString)!, longitude: CLLocationDegrees(longiString)!)
        marker.title = titleString
        self.mapView.animate(to: camera)
        marker.map = self.mapView
        
        let position = CLLocation(latitude: CLLocationDegrees(latiString)!, longitude: CLLocationDegrees(longiString)!)
        drawpath(startLocation: currentLocation!, endLocation: position)
            
        
    }
    
    func drawpath(startLocation: CLLocation , endLocation: CLLocation){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON {(respose) in
            let routeDictionary = respose.result.value as! [String:Any]
            let Array = routeDictionary["routes"] as! NSArray
            
            for i:Int in 0 ..< Array.count{
                
                let routes = Array[i] as! Dictionary<String,Any>
                
                let legs = routes["legs"] as! NSArray
                for i:Int in 0 ..< legs.count{
                    let legData = legs[i] as! Dictionary<String,Any>
                    let distanceData = legData["distance"] as! Dictionary<String,Any>
                    let actualDistance = distanceData["text"] as! String
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
                    marker.icon = UIImage(named: "car")
                    marker.title = actualDistance
                    marker.map = self.mapView
                    
                    
                    
                }
                
                
                let routeOverviewPolyline = routes["overview_polyline"] as! Dictionary<String,Any>
                
                
                
                let points = routeOverviewPolyline["points"] as! String
                
                let path = GMSPath(fromEncodedPath: points)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
            
        }
        
    }
    

}
