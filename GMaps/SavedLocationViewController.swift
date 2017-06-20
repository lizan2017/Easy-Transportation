//
//  SavedLocationViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit

class SavedLocationViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var savedLocationTableView: UITableView!
    var latitudeArray:[String] = []
    var longitudeArray:[String] = []
    var nameArray:[String] = []
    var lati:[Latitude]?
    var logi:[Longitude]?
    var name:[Name]?
    override func viewDidLoad() {
        super.viewDidLoad()
        savedLocationTableView.delegate = self
        savedLocationTableView.dataSource = self
        self.title = "Saved Locations"
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        latitudeArray = []
        longitudeArray = []
        nameArray = []
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "h6"), style: .plain, target: self, action: #selector(toggleSideMenu))
        
        self.fetchData()
        
    }

    func toggleSideMenu() {
       
        self.revealViewController().revealToggle(animated: true)
    }
    
    func fetchData() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do{
            lati = try context.fetch(Latitude.fetchRequest())
            logi = try context.fetch(Longitude.fetchRequest())
            name = try context.fetch(Name.fetchRequest())
            
            for i:Int in 0 ..< lati!.count {
                let latValue = lati![i]
                let lonValue = logi![i]
                let nameValue = name![i]
                
                latitudeArray.append(latValue.lat!)
                longitudeArray.append(lonValue.lon!)
                nameArray.append(nameValue.name!)
            }
            
        }catch{
            
        }
        savedLocationTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latitudeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slcell") as! SavedLocationCell
        cell.titleLabel.text = nameArray[indexPath.row]
        cell.latitudeLabel.text = latitudeArray[indexPath.row]
        cell.longitudeLabel.text = longitudeArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SavedLocationCell
        let titelString = cell.titleLabel.text
        let latString = cell.latitudeLabel.text
        let lonString = cell.longitudeLabel.text
        let sb = self.storyboard
        let mapView = sb?.instantiateViewController(withIdentifier: "smvc") as! SavedMapViewController
        mapView.titleString = titelString!
        mapView.latiString = latString!
        mapView.longiString = lonString!
        
        navigationController?.pushViewController(mapView, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        if editingStyle == .delete{
            let latitude = lati![indexPath.row]
            let longitude = logi![indexPath.row]
            let nameData = name![indexPath.row]
            
            context.delete(latitude)
            context.delete(longitude)
            context.delete(nameData)
            
            do{
                try context.save()
                viewWillAppear(true)
                savedLocationTableView.reloadData()
            }catch{
                
            }
            
        }
    }
    @IBAction func cancelTaped(_ sender: Any) {
        self.revealViewController().bounceBackOnLeftOverdraw = true
        let sb = self.storyboard
        let mapView = sb?.instantiateViewController(withIdentifier: "mapVC")
        
        self.navigationController?.pushViewController(mapView!, animated: true)
    }
    
  
}
