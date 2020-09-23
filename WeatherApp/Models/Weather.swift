//
//  Weather.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

struct Weatherr: Decodable {
    
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let name: String?
}

struct Main: Decodable {
    
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
}

struct Sys: Decodable {
    
    let type: Int?
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Decodable {
    
    let main, description, icon: String?
}



