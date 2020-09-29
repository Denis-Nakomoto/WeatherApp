//  MetworkManager.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//
import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
//    func fetchData(_ city:String, completion:@escaping (_ weather: TopWeather)->(), httpResponse: @escaping (_ responseCode: Int)->()) {
//        guard let url = URL (string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665&lang=ru&units=metric")
//        else {
//            print ("INCORECT URL")
//            return
//        }
//        let request = URLRequest (url: url)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response as? HTTPURLResponse {
//                httpResponse(response.statusCode)
//                print (response)
//            } else { return }
//            guard let data = data else {
//                print ("No data in response:\(error?.localizedDescription ?? "Unknown error").")
//                return
//            }
//            do {
//                let weather = try JSONDecoder().decode(TopWeather.self, from: data)
//                completion(weather)
//            }
//            catch let err {
//                print (err)
//            }
//        }.resume()
//    }
    
//    func alamofireFetchWeather(_ city: String, completion:@escaping (_ weather: TopWeather)->()) {
//        AF.request ("http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665&lang=ru&units=metric")
//            .validate()
//            .responseDecodable(of: TopWeather.self) { weather in
//                switch weather.result {
//                case .success(let value):
//                    completion(value)
//                    print("ALOMOFIRE \(value)")
//                case .failure(let error):
//                    print(error)
//                }
    //            }
    //    }
    
    func alamofireFetchWeather(_ city: String, completion:@escaping (_ weather: TopWeather)->(), status:@escaping (_ statusCode: Int)->()) {
        let url:String = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665&lang=ru&units=metric"
        AF.request(url).responseData { (response) in
          
            guard let statusCode = response.response?.statusCode else { return }
            if (200..<300).contains(statusCode) {
                switch response.result {
                case .success(let data):
                    do {
                        let weather = try JSONDecoder().decode(TopWeather.self, from: data)
                        completion(weather)
                        print("ALOMOFIRE \(weather)")
                    }
                    catch let err {
                        print ("ERR \(err)")
                    }
                case .failure (let error):
                    print("ERROR \(error)")
                }
            } else {
                guard let error = response.response?.statusCode else { return }
                status(error)
            }
        }
    }
}
