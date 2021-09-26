//
//  CitiesProviderProtocol.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 26.09.2021.
//

import Foundation


protocol CitiesProviderProtocol {
    func getCities() -> [City]
    func saveCity(city: City) throws
}
