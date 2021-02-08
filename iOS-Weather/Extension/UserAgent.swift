//
//  UserAgent.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 06/02/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

public class UserAgent {
    public static let shared = UserAgent()
    private var locManager = CLLocationManager()

    init() {
        locManager.requestWhenInUseAuthorization()
    }
    
    public func getData() -> UserDefaultInformations {
        let location = getLocation()
        return UserDefaultInformations(latitude: location.lat ?? "", longitude: location.lon ?? "")
    }
    
    public func openSettings() {
        callSettings()
    }
    
    public func openAlertSettings(handler: @escaping (() -> Void) ) {
        askForSettingsLocation(handler: handler)
    }

    
    public func isLocationEnabled() -> Bool {
        return locationManager()
    }
    
}

extension UserAgent {
    private func locationManager() -> Bool {
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedAlways
            || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    
    private func askForSettingsLocation(handler: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: "", message: "Você deve permitir a localização nas configurações para realizar o saque!", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
            self.callSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) {(_) -> Void in
            return handler()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                break
            case .restricted, .denied:
                break
            case .notDetermined:
                locManager.requestWhenInUseAuthorization()
        }
    }
    
    private func callSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
        }
    }

    
    private func getLocation() -> (lat: String?, lon: String?) {
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways
            || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locManager.startUpdatingLocation()
            locManager.stopUpdatingLocation()
            currentLocation = locManager.location
            if let lat = currentLocation?.coordinate.latitude, let lon = currentLocation?.coordinate.longitude {
                return (lat: String(Int(lat)), lon: String(Int(lon)))
            } else {
                return (lat: nil, lon: nil)
            }
        } else {
            return (lat: nil, lon: nil)
        }
    }
}

public struct UserDefaultInformations: Codable {
    var latitude: String
    var longitude: String
}
