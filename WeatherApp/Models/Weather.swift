//
//  Weather.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

struct TopWeather: Decodable {
    
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let dt: Int?
    let sys: Sys?
    let name: String?
    let cod: Int?
}

struct Main: Decodable {
    
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
}

struct Sys: Decodable {
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Decodable {
    let id: Int?
    let main, description: String?
}


