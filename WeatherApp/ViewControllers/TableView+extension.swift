//
//  TableView+extension.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 26.09.2020.
//

import UIKit


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let title = tableRows[indexPath.row]
        let subtitle = tableValues[indexPath.row]
        tableView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clear
    }
    
    func makeTableDictionary(for weather: TopWeather) {
    
    }
}
