//
//  MetworkManager.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//
import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchData(_ city:String, completion:@escaping (_ weather: TopWeather)->(), httpResponse: @escaping (_ responseCode: Int)->()) {
            guard let url = URL (string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665&lang=ru&units=metric")
            else {
                print ("INCORECT URL")
                return
            }
            let request = URLRequest (url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    httpResponse(response.statusCode)
                    print (response)
                } else { return }
                guard let data = data else {
                    print ("No data in response:\(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                do {
                    let weather = try JSONDecoder().decode(TopWeather.self, from: data)
                    completion(weather)
                }
                catch let err {
                    print (err)
                }
            }.resume()
        }

    func alamofireFetchWeather(_ city: String, completion:@escaping (_ weather: TopWeather)->()) {
        AF.request ("http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3ba8ae3fa0cf1637f39c837ec7ec8665")
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
// Алексей, я не смог распарсить модель weather. Раскажи где я накосячил.
                    guard let weatherData = value as? [String:Any] else { return }
                    let weatherr = weatherData ["weather"] as? [String:Any]
                    let mainn = weatherData ["main"] as? [String:Any]
                    let syss = weatherData ["sys"] as? [String:Any]
                    
                    let weather = Weather(
                        id: weatherr?["id"] as? Int,
                        main: weatherr?["main"] as? String,
                        description: weatherr?["description"] as? String
                    )
                    
                    let main = Main(
                        temp: mainn? ["temp"] as? Double,
                        feelsLike: mainn? ["feelsLike"] as? Double,
                        tempMin: mainn? ["tempMin"] as? Double,
                        tempMax: mainn? ["tempMax"] as? Double,
                        pressure: mainn? ["pressure"] as? Int,
                        humidity: mainn? ["humidity"] as? Int
                    )

                    let sys = Sys(
                        country: syss? ["country"] as? String,
                        sunrise: syss? ["sunrise"] as? Int,
                        sunset: syss? ["sunset"] as? Int
                    )

                    let parsedWeather = TopWeather(
                        weather: [weather],
                        main: main,
                        visibility: weatherData ["visibility"] as? Int,
                        dt: weatherData ["dt"] as? Int,
                        sys: sys,
                        name: weatherData ["name"] as? String,
                        cod: weatherData ["cod"] as? Int
                    )
                    print("ALAMOFIRE\(parsedWeather)")
                    completion(parsedWeather)

                case .failure(let error):
                    print(error)
                }
            }
    }
}
