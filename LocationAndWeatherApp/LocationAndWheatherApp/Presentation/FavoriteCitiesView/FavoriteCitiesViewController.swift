//
//  FavoriteCitiesViewController.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 24.09.2021.
//

import UIKit
import MapKit

final class FavoriteCitiesViewController: UIViewController{

    @IBOutlet weak var favoriteCitiesTableView: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherInformation: [WeatherInformation] = []
    
    private let viewModel: FavoriteCitiesViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCitiesTableView.delegate = self
        favoriteCitiesTableView.dataSource = self

        viewModel.getCitiesFromFavorite()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCities), name: Notification.Name("NewCityAdded"), object: nil)
    }
    
    @objc func refreshCities(){
        viewModel.getCitiesFromFavorite()
        favoriteCitiesTableView.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = FavoriteCitiesViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        viewModel = FavoriteCitiesViewModel()
        super.init(coder: coder)
    }
    
    private func getTemperatureInCity(latitude: Double, longitude: Double) {
        viewModel.loadData(longitude: longitude, latitude: latitude) { [weak self] temperature in
            self?.weatherAlert(temperatura: temperature)
        }
    }

    private func weatherAlert(temperatura: String){
        let alert = UIAlertController(title: "Температура в данном городе \(temperatura)", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        loadingAnimation()
        present(alert, animated: true, completion: nil)
    }
    
    private func loadingAnimation(){
        loadingView.isHidden = !loadingView.isHidden
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }else { activityIndicator.startAnimating()}
    
    }
}

extension FavoriteCitiesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadingAnimation()
        let geoposition = viewModel.cities[indexPath.row]
        getTemperatureInCity(latitude: geoposition.latitude, longitude: geoposition.longitude)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = viewModel.cities[indexPath.row].name
        return cell
    }
    
    
}
extension FavoriteCitiesViewController: RealmContaining{
    
}
