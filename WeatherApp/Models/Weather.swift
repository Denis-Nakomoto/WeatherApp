//
//  Weather.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

struct TopWeather: Codable {
    
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let dt: Int?
    let sys: Sys?
    let name: String?
    let cod: Int?
    
    init(value: [String:Any]) {
        let weatherDict = value["weather"] as? [String:Any] ?? [:]
        let mainDict = value["main"] as? [String:Any] ?? [:]
        let sysDict = value["sys"] as? [String:Any] ?? [:]
        weather = [Weather(value: weatherDict)]
        main = Main(value: mainDict)
        visibility = value["visibility"] as? Int
        dt = value["dt"] as? Int
        sys = Sys(value: sysDict)
        name = value["name"] as? String
        cod = value["cod"] as? Int
    }
}

struct Main: Codable {
    
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
    
    init(value: [String: Any]) {
        temp = value ["temp"] as? Double
        feelsLike = value ["feelsLike"] as? Double
        tempMin = value ["tempMin"] as? Double
        tempMax = value ["tempMax"] as? Double
        pressure = value ["pressure"] as? Int
        humidity = value ["humidity"] as? Int
    }
}

struct Sys: Codable {
    let country: String?
    let sunrise, sunset: Int?
    
    init(value: [String: Any]){
        country = value ["country"] as? String
        sunrise = value ["sunrise"] as? Int
        sunset = value ["sunset"] as? Int
    }
}

struct Weather: Codable {
    let id: Int?
    let main, description: String?
    
    init(value: [String: Any]) {
        id = value["id"] as? Int
        main = value["main"] as? String
        description = value["description"] as? String
    }
}


