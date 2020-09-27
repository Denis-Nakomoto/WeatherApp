//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var weather: TopWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (String(describing: weather))
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
                return 1
            } else if section == 1 {
                return 4
            }
            return 0
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell", for: indexPath) as! FirstCell
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "dinamicCell", for: indexPath)
//                if let weather = weather {
//                    cell.textLabel?.text = weather.name
//                }
//                    else { cell.textLabel?.text = "name" }
//                return cell
//            }
//    }

}
