//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Batuhan Berk Ertekin on 4.07.2024.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var temp: Double = 0.0
    @Published var description: String = ""
    @Published var icon: String = ""
    @Published var windSpeed : Double = 0.0
    @Published var humidity: Int = 0
    @Published var pressure: Int = 0
    @Published var maxTemp: Double = 0.0
    @Published var minTemp: Double = 0.0
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
        fetchWeather()
    }
    
    func fetchWeather(for city: String = "istanbul") {
        networkManager.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.name = data.name
                    self.temp = data.main.temp
                    self.description = data.weather.first?.description ?? ""
                    self.icon = data.weather.first?.icon ?? ""
                    self.windSpeed = data.wind.speed
                    self.humidity = data.main.humidity
                    self.pressure = data.main.pressure
                    self.maxTemp = data.main.tempMax
                    self.minTemp = data.main.tempMin
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching weather: \(error.localizedDescription)")
                   
                }
            }
        }
    }
}

