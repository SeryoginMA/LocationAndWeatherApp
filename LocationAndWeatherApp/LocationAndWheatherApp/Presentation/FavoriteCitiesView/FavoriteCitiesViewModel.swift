//
//  FavoriteCitiesViewModel.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 25.09.2021.
//

import Foundation
import CoreLocation


protocol FavoriteCitiesViewModelProtocol {
    func loadData(longitude: Double, latitude: Double, completion: @escaping (String) -> Void)
    func getCitiesFromFavorite()
    var cities: [City] { get }

}

final class FavoriteCitiesViewModel: FavoriteCitiesViewModelProtocol {
    
    private let weatherProvider: WeatherProviderProtocol = WeatherProvider()
    private let citiesProvider: CitiesProviderProtocol = CitiesProvider()

    private(set) var cities: [City] = []

    
    
    func getCitiesFromFavorite() {

        cities = self.citiesProvider.getCities()
    }

    func loadData(longitude: Double, latitude: Double, completion: @escaping (String) -> Void) {
        weatherProvider.loadData(longitude: longitude, latitude: latitude) { temperature in
            let sign = temperature > 0 ? "+" : "-"
            completion("\(sign)\(temperature)°С")
        }
    }

}
