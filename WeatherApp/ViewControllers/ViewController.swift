//
//  ViewController.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        NetworkManager.shared.fetchData(cityTextField.text ?? "London") { weather in
            DispatchQueue.main.sync {
                detailVC.weather = weather
                detailVC.tableView.reloadData()
                print (String(describing: weather))
            }
        }
    }
    
    @IBAction func getWeatherButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetails", sender: sender)
    }
}

