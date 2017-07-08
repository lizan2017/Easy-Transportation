//
//  ViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/7/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire

class ViewController: UIViewController , UISearchBarDelegate, CLLocationManagerDelegate , GMSMapViewDelegate , GMSAutocompleteViewControllerDelegate{
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var googleContainer: UIView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var defalutBtn: UIButton!
    @IBOutlet weak var satelliteBtn: UIButton!
    
    
    
    
    var currentLocation:CLLocation?
    var googleMaps : GMSMapView!
    var locationManager :CLLocationManager!
    var latArray:Array<String> = []
    var lonArray:Array<String> = []
    var nameArray:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map View"
        self.googleMaps = GMSMapView()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMap()
        
        
       
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 250.0
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
        
    }

   
  
    func initGoogleMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: 27.7172, longitude: 85.3240, zoom: 15)
        let mapRect:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        googleMaps = GMSMapView.map(withFrame: mapRect, camera: camera)
        
        
        self.googleMaps.delegate = self
        
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.isMyLocationEnabled = true
        
        
        googleMaps.settings.compassButton = true
        
        view.addSubview(googleMaps)
        view.addSubview(satelliteBtn)
        view.addSubview(defalutBtn)
       
        
        satelliteBtn.layer.cornerRadius = 25
        defalutBtn.layer.cornerRadius = 25
        satelliteBtn.layer.borderColor = UIColor.black.cgColor
        defalutBtn.layer.borderColor = UIColor.black.cgColor
        satelliteBtn.layer.borderWidth = 2.0
        defalutBtn.layer.borderWidth = 2.0
        
    
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
       
       
    }
    
    @IBAction func defaultBtnTapped(_ sender: Any) {
        googleMaps.mapType = GMSMapViewType.normal
    }
    
    @IBAction func satelliteTapped(_ sender: Any) {
        googleMaps.mapType = GMSMapViewType.satellite
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func googleSearchAdress(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        
        autoCompleteController.delegate = self
        autoCompleteController.tableCellBackgroundColor = UIColor.darkGray
        autoCompleteController.primaryTextColor = UIColor.lightGray
        autoCompleteController.primaryTextHighlightColor = UIColor.white
        autoCompleteController.secondaryTextColor = UIColor.lightGray
        autoCompleteController.tableCellSeparatorColor = UIColor.gray
        UIApplication.shared.statusBarStyle = .default
        autoCompleteController.tintColor = UIColor.white
        self.locationManager.startUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        currentLocation = location
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)! , zoom: 15)
        self.googleMaps.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
       
    }
  
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMaps.isMyLocationEnabled = true
        if (gesture){
            mapView.selectedMarker = nil
        }
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace){
        
        self.googleMaps.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
        self.googleMaps.camera = camera
        let marker = GMSMarker()
        let position = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        if place.phoneNumber != nil { marker.snippet = place.phoneNumber!}
        marker.appearAnimation = GMSMarkerAnimation.pop
        
        marker.map = self.googleMaps
        self.dismiss(animated: true
            , completion: nil)
       
        locationpath(startLocation: currentLocation!, endLocation: position)
        
        
    }
    
    func locationpath(startLocation: CLLocation, endLocation: CLLocation){
        let locationS = startLocation
        let locationE = endLocation
        
        if saveSwitchON.isOn {
            drawpath(startLocation: locationS, endLocation: locationE)
        }else{
            return
            
        }
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
        
    }
    @IBOutlet weak var saveSwitchON: UISwitch!
    
    @IBAction func saveSwitch(_ sender: Any) {
        
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
                    marker.map = self.googleMaps
                    
                    
                    
                }
                
           
            let routeOverviewPolyline = routes["overview_polyline"] as! Dictionary<String,Any>
            
        
            
            let points = routeOverviewPolyline["points"] as! String
            
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.googleMaps
            }
          
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       
        googleMaps.clear()
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        self.googleMaps.camera = camera
        let marker = GMSMarker()
        marker.position = coordinate
        let geocode = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocode.reverseGeocodeLocation(location, completionHandler: {(placeMarks, error) in
            let place = placeMarks![0]
            let placeName = place.name!
           
            marker.title = placeName
            if place.locality != nil{
                marker.snippet =  place.locality!}else{
                
            }
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.googleMaps
        })
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let lat = marker.position.latitude
        let lon = marker.position.longitude
        let name = marker.title
        let alert = UIAlertController(title: "",message: "Save Location?", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {_ in
            
            if name == nil{
                return
            }else{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let latEntity = Latitude(context: context)
            let lonEntity = Longitude(context: context)
            let nameEntity = Name(context: context)
            
            latEntity.lat = String(lat)
            lonEntity.lon = String(lon)
            nameEntity.name = name
            do{
            try context.save()
        
            }catch{
                
                }}
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
       
        
    }
   
}

