//
//  ViewController.swift
//  WeatherApp
//
//  Created by Denis Svetlakov on 22.09.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let maxHeaderHeight: CGFloat = 200
    private let minHeaderHeight: CGFloat = 80
    private var previousScrollOffset: CGFloat = 0
    var parsedWeather: TopWeather!
    
    var tableRows = [
        "Видимость","Город","Температура","Ощущается как","Минимальная температура",
        "Максимальная температура","Давление","Влажность","Страна","Восход","Закат","Описание"
    ]
    
    var tableValues = [
        "Видимость","Город","Температура","Ощущается как","Минимальная температура",
        "Максимальная температура","Давление","Влажность","Страна","Восход","Закат","Описание"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        getWeather(for: "Cupertino")
        NetworkManager.shared.alamofireFetchWeather("Cupertino") { weather in
            print (weather)
        }
    }
    
    @IBAction func searchButtonPressed() {
        getWeather(for: searchTextField.text ?? "Paris")
    }
    
    private func checkResponse(_ response: Int) {
        if 0..<200 ~= response || 300...10000 ~= response{
            self.showAlert(title: "Ошибка", message:("Получены неверные данные от сервера. Вводить город следует на латиннице"))
        }
        else {
        }
    }
    
    private func getWeather(for city: String) {
        NetworkManager.shared.fetchData(city) { weather in
            DispatchQueue.main.async {
                self.parsedWeather = weather
                self.setHeader(weather)
                self.setBackgroundImage(weather)
                // Алексей. Мне тоже этот монстр не нравиться
                self.tableValues = [
                    String(format: "%.f", weather.visibility ?? ""),
                    (weather.name ?? ""),
                    String(format: "%.f", weather.main?.temp ?? ""),
                    String(format: "%.f", weather.main?.feelsLike ?? ""),
                    String(format: "%.f", weather.main?.tempMin ?? ""),
                    String(format: "%.f", weather.main?.tempMax ?? ""),
                    String(format: "%.f", weather.main?.pressure ?? ""),
                    String(format: "%.f", weather.main?.humidity ?? ""),
                    (weather.sys?.country ?? ""),
                    String(format: "%.f", weather.sys?.sunrise ?? ""),
                    String(format: "%.f", weather.sys?.sunset ?? ""),
                    (weather.weather?.first?.description ?? "")
                ]
                self.tableView.reloadData()
                print (weather)
            }
        } httpResponse: { responseCode in
            DispatchQueue.main.async {
                self.checkResponse(responseCode)
            }
        }
    }
    // MARK: Set heder fuelds and image
    private func setHeader (_ weather: TopWeather) {
        cityLabel.text = weather.name
        descriptionLabel.text = weather.weather?.first?.description
        weatherImage.image = setWeatherImage(weather)
        if let temp = weather.main?.temp {
            self.temperatureLabel.text = "\(String(format: "%.f", temp))°C"
        } else { self.temperatureLabel.text = "0°C"}
    }
    
    private func setWeatherImage(_ weather: TopWeather) -> UIImage{
        if let id = weather.weather?.first?.id {
            var weatherImage: UIImage {
                switch id {
                case 200...232:
                    return #imageLiteral(resourceName: "Thunder")
                case 300...321:
                    return #imageLiteral(resourceName: "Partly Cloudy & Rainy")
                case 500...531:
                    return #imageLiteral(resourceName: "Cloudy & Rainy")
                case 600...622:
                    return #imageLiteral(resourceName: "Cloudy & Snowy")
                case 701...781:
                    return #imageLiteral(resourceName: "Cloudy & Foggy")
                case 800:
                    return #imageLiteral(resourceName: "Sunny")
                case 801...804:
                    return #imageLiteral(resourceName: "Cloudy")
                default:
                    return #imageLiteral(resourceName: "Sunny & Foggy")
                }
            }
            return weatherImage
        } else { return #imageLiteral(resourceName: "Partly Cloudy")}
    }
    
    private func setBackgroundImage(_ weather: TopWeather){
        if let id = weather.weather?.first?.id {
            var weatherImage: UIImage {
                switch id {
                case 200...232:
                    return #imageLiteral(resourceName: "Thunderstorm")
                case 300...321:
                    return #imageLiteral(resourceName: "Drizzle")
                case 500...531:
                    return #imageLiteral(resourceName: "Rain")
                case 600...622:
                    return #imageLiteral(resourceName: "Snow")
                case 701...781:
                    return #imageLiteral(resourceName: "Fogg")
                case 800:
                    return #imageLiteral(resourceName: "Clear")
                case 801...804:
                    return #imageLiteral(resourceName: "Clouds")
                default:
                    return #imageLiteral(resourceName: "Clear")
                }
            }
            let imageView = UIImageView(image: weatherImage)
            self.view.backgroundColor = .white
            self.tableView.backgroundView = imageView
            imageView.alpha = 0.6
            imageView.contentMode = .scaleAspectFill
        } else { return }
    }
    
    //MARK: Alert controller
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

//MARK: Expandable header extension
extension ViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = (scrollView.contentOffset.y - previousScrollOffset)
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        if canAnimateHeader(scrollView) {
            var newHeight = headerViewHeight.constant
            if isScrollingDown {
                newHeight = max(minHeaderHeight, headerViewHeight.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(maxHeaderHeight, headerViewHeight.constant + abs(scrollDiff))
            }
            if newHeight != headerViewHeight.constant {
                headerViewHeight.constant = newHeight
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
            }
        }
    }
    
    private func canAnimateHeader (_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerViewHeight.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func setScrollPosition() {
        self.tableView.contentOffset = CGPoint(x:0, y: 0)
    }
}

//MARK: Text Field methods
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            getWeather(for: city)
        }
        searchTextField.text = ""
    }
    
}


