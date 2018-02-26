//
//  SelectCountryViewController.swift
//  Holimate
//
//  Created by Omeesh Sharma on 20/05/17.
//  Copyright © 2017 Relinns Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
protocol selectedCountry: class {
    func data(country: String,code:String)
}


class SelectCountryViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var srchField: UITextField!
    
    @IBOutlet var table: UITableView!
    var countryArray = [[String:Any]]()
    
    var array = [[String:Any]]()
    
    //var newArray = [[String:Any]]()
    var searchArray = [[String:Any]]()
    
    weak var delegate: selectedCountry?
    
    
    @IBOutlet var saveOut: UIBarButtonItem!
    
    var select = [false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveOut.title = ""
        
        
        self.table.tableFooterView = UIView()
        
        self.table.delegate = self
        self.table.dataSource = self
        
        countryArray = Api.sharedInstance.getCountryArray()! as! [[String : Any]]
        for var i in countryArray {
            i["flag" ] = false
            array.append(i)
            searchArray.append(i)
        }
        countryArray = array
        
    }
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func didEndEditing(_ sender: UITextField) {
    }
    
    
    
    @IBAction func didChange(_ sender: UITextField) {
        
        if sender.text?.isEmpty == true{
            
            self.searchArray = self.array
            self.table.reloadData()
        }else{
            
            
            self.searchArray = self.array.filter{
                let str = ($0["name"] as! String).lowercased()
                return (str.range(of: sender.text!.lowercased()) != nil)
            }
        }
        
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! SelectCountryTableViewCell
        let text =  "+\(self.searchArray[indexPath.row]["code"] as! String)  \(self.searchArray[indexPath.row]["name"] as! String) "
        cell.count.text = text
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.srchField.text?.isEmpty == true {
            return array.count
        }else{
            return searchArray.count
        }
        
    }
    
    
    var countArray = [String]()
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.data(country: self.searchArray[indexPath.row]["name"] as! String, code: self.searchArray[indexPath.row]["id"] as! String)
        _=self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    
    
    var count1 = String()
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        
        self.countArray.removeAll()
        for i in 0..<array.count{
            if   (array[i]["flag"] as! Bool) == true {
                let dict = array[i] as NSDictionary
                let count =  "\(dict.value(forKey: "name")!)"
                self.count1 = count
                self.countArray.append(count)
            }
        }
        
        self.delegate?.data(country: count1, code: "")
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
}
