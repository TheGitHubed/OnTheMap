//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/8/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var locationsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableView.dataSource   = self
        locationsTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationsTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationFactory.shared.studentLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //locationCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let location = LocationFactory.shared.studentLocations[(indexPath as NSIndexPath).row]
        cell.textLabel?.text =   "\(location.firstName ?? "") \(location.lastName ?? "")"
        cell.detailTextLabel?.text = location.mediaURL
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if var toOpen = LocationFactory.shared.studentLocations[(indexPath as NSIndexPath).row].mediaURL {
            if    !toOpen.contains("http")
            {
                toOpen = "http://" + toOpen
            }
            if  let url = URL(string: toOpen), app.canOpenURL(url){
                app.open(url, options: [:], completionHandler: nil)
            }
        }
        
    }
    
}
