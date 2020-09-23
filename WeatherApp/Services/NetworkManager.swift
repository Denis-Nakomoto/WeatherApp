//
//  MetworkManager.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//
import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func fetchData(_ city:String, completion:@escaping (_ weather: Weatherr)->()) {
        let url = URL (string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665")
        let request = URLRequest (url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
//            print (String(decoding: data!, as: UTF8.self))
            if let httpResponse = response as? HTTPURLResponse {
                print (httpResponse.statusCode)
            } else { assertionFailure("unexpected response") }
            guard let data = data else {
                print ("No data in response:\(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weatherr.self, from: data)
                completion(weather)
            }
            catch let err {
                print (err)
            }
        }.resume()
    }
}
