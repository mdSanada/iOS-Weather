//
//  Alert.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 06/02/21.
//

import UIKit

public class Alert {
    public static let shared = Alert()
    
    func show(message: String, controller: UIViewController, handler: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: "Atenção!", message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
            handler()
        }
        alertController.addAction(settingsAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
