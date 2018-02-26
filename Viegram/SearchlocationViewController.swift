//
//  SearchlocationViewController.swift
//  Viegram
//
//  Created by Relinns on 02/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import Lottie
protocol locationfetch: class {
    func location(loc: String)
}
class SearchlocationViewController: UIViewController , CLLocationManagerDelegate,UITableViewDelegate , UITableViewDataSource{
    //
    var locationManager = CLLocationManager()
    var locationString = ""
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var searchTf: UITextField!
    
    weak var delegate: locationfetch?
    
    var circularview:CircularMenu?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTf.text = self.locationString
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5
        
        self.tableview.estimatedRowHeight = 60
        self.tableview.rowHeight = UITableViewAutomaticDimension
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
        
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            self.setPaddingView(strImgname: "Search", txtField: self.searchTf)
            self.searchTf.layer.borderWidth = 0.5
            self.searchTf.layer.borderColor = apppurple.cgColor
            
            animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
            
            
            // cllocation mananger
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
           
            self.locationManager.distanceFilter = 1000
            
            if (CLLocationManager.locationServicesEnabled()){
                self.locationManager.startUpdatingLocation()
            }
            else{
                self.showalertview(messagestring: "Location services are not enabled")
            }
        }
    }
    
    
    
    
    
    
    @IBAction func search(_ sender: UITextField) {
        guard sender.text?.isEmpty == false else{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            return
        }
        let placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        
        placesClient.autocompleteQuery(sender.text!, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.searchResult = results
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
            
        })
    }
    
    
    
    
    
    func setPaddingView(strImgname: String,txtField: UITextField){
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: -5, y: 0, width: 20 , height: 20)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
  
    }
    
    @IBAction func donebtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }

    var long = Float()
    var lat = Float()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        long = Float(locValue.longitude)
        lat = Float(locValue.latitude)
        self.apicall()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var locationArr1 = [String]()
    var searchResult = [GMSAutocompletePrediction]()
    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"search_location" ,"latitude": "\(lat)","longitude":"\(long)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                animationView.pause()
                animationView.removeFromSuperview()
                return
            }
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            let locationsArr = ((json["result"]["places_detail"].arrayValue).map({$0["place_name"].stringValue}))
            self.locationArr1 = locationsArr
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchTf.text?.isEmpty == true{
            return locationArr1.count
        }else{
           return searchResult.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchlocTableViewCell
        let value = self.searchTf.text?.isEmpty == true ? (locationArr1[indexPath.row] ) : (searchResult[indexPath.row].attributedFullText.string)
        cell.loc.text = value
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.searchTf.text?.isEmpty == true ? (locationArr1[indexPath.row]) : (searchResult[indexPath.row].attributedFullText.string)
        let str =  value
        self.searchTf.text = value
        self.delegate?.location(loc: str)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //
}
