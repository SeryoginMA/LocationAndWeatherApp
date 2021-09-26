//
//  CitiesProvider.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 26.09.2021.
//

import Foundation

final class CitiesProvider: CitiesProviderProtocol, RealmContaining {

    func getCities() -> [City] {
        let cities = Array(getFromRealm(City.self).map(City.init))
        return cities
    }

    func saveCity(city: City) throws {
        try saveToRealm(city)
    
    }

}
