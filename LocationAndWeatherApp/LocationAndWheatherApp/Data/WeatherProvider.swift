//
//  WeatherProvider.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 26.09.2021.
//

import Foundation

private enum Constants {
    static func tempratureURL(latitude: Double, longitude: Double) -> String {
        "https://www.7timer.info/bin/astro.php?lon=\(longitude)&lat=\(latitude)&unit=metric&output=json"
    }
}

final class WeatherProvider: WeatherProviderProtocol {

    func loadData(longitude: Double, latitude: Double, completion: @escaping (Int) -> Void) {
        guard let url = URL(string: Constants.tempratureURL(latitude: latitude, longitude: longitude)) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonResult.dataseries[0].temp2m)
                }
            }
            catch {
                print(error)
            }
        }

        task.resume()
    }

}
