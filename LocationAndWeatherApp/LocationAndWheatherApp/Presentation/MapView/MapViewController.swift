//
//  MapViewController.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 24.09.2021.
//

import UIKit
import MapKit


final class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    private let viewModel: MapViewModelProtocol
    private var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationEnabled()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = MapViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        viewModel = MapViewModel()
        super.init(coder: coder)
    }

    @IBAction private func addToFavoriteButtonClicked(_ sender: Any) {
        guard let location = locationManager.location else { return }

        viewModel.addCityToFavorite(location: location)
    }
    
    @IBAction private func geopositionButtonClicked(_ sender: Any) {
        guard let location = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        getTemperature(latitude: location.latitude, longitude: location.longitude)
    }
    
    private func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkLocationAuthorizationStatus()
        } else {
            let alert = UIAlertController(title: "Служба геолокацции выключена", message: "Для определения Вашего местоположения необходимо включить геолокацию", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    private func checkLocationAuthorizationStatus() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func getTemperature(latitude: Double, longitude: Double) {
        viewModel.loadData(longitude: longitude, latitude: latitude) { [weak self] temperature in
            self?.temperatureLabel.text = temperature
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        getTemperature(latitude: location.latitude, longitude: location.longitude)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }

}
