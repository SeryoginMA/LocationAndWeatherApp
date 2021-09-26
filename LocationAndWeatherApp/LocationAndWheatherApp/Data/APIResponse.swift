//
//  APIResponse.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 24.09.2021.
//

import Foundation

struct APIResponse: Codable {
    let dataseries: [WeatherInformation]
}

struct WeatherInformation: Codable {
    let temp2m: Int
}
