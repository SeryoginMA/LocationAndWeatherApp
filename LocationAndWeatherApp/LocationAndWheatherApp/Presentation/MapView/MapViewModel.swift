//
//  MapViewModel.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 25.09.2021.
//

import Foundation
import CoreLocation


protocol MapViewModelProtocol {
    func loadData(longitude: Double, latitude: Double, completion: @escaping (String) -> Void)
    func addCityToFavorite(location: CLLocation)
}

final class MapViewModel: MapViewModelProtocol {

    private let weatherProvider: WeatherProviderProtocol = WeatherProvider()
    private let citiesProvider: CitiesProviderProtocol = CitiesProvider()

    private lazy var cities: Set<String> = Set(citiesProvider.getCities().map(\.name))

    func addCityToFavorite(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            guard
                let self = self,
                let cityName = (placemarks?.first?.locality),
                !self.cities.contains(cityName)
           else {
               return
           }

            self.cities.insert(cityName)
            let city = City()
            city.latitude = location.coordinate.latitude
            city.longitude = location.coordinate.longitude
            city.name = cityName
            try? self.citiesProvider.saveCity(city: city)
            NotificationCenter.default.post(name: Notification.Name("NewCityAdded"), object: nil)
        })
    }

    func loadData(longitude: Double, latitude: Double, completion: @escaping (String) -> Void) {
        weatherProvider.loadData(longitude: longitude, latitude: latitude) { temperature in
            let sign = temperature > 0 ? "+" : "-"
            completion("\(sign)\(temperature)°С")
        }
    }

}
