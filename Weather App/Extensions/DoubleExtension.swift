//
//  DoubleExtension.swift
//  Weather App
//
//  Created by Batuhan Berk Ertekin on 1.07.2024.
//

import Foundation

extension Double {
    func formattedTemperature() -> String {
        return String(format: "%.1f°C", self)
    }
    
    func formattedWindSpeed() -> String {
        return String(format: "%.1f m/s", self)
    }
}

