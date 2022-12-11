//
//  AlertHelper.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 04.12.2022.
//

import Foundation
import UIKit

final class AlertHelper {

    static func showErrorAlert(_ error: Error) {
        let title = "error_alert_title".localized
        let message = error.localizedDescription
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            UIApplication.currentController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showNoInternetAlert() {
        let message = "no_internet_message".localized
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        alert.addAction(okAction)
        UIApplication.currentController()?.present(alert, animated: true, completion: nil)
    }
    
    class func presentOpenSettingsAlert() {
        let title = "You have denied the access previously".localized
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default, handler: { _ -> Void in
            self.openSettings()
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        alert.preferredAction = settingsAction

        DispatchQueue.main.async {
            UIApplication.currentController()?.present(alert, animated: true, completion: nil)
        }
    }

    private class func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
