//
//  WeatherProviderProtocol.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 26.09.2021.
//

import Foundation

protocol WeatherProviderProtocol {
    func loadData(longitude: Double, latitude: Double, completion: @escaping (Int) -> Void)
}
