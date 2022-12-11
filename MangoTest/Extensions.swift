//
//  Extensions.swift
//  RelationshipMediator
//
//  Created by yurii.devyataev on 10.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable comment_spacing

// MARK: - String
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func sizeInTextView(font: UIFont?) -> CGSize {
        let textView = UITextView()
        textView.font = font
        textView.text = self
        textView.sizeToFit()
        return textView.frame.size
    }
    
    func size(font: UIFont?, maxWidth: CGFloat) -> CGSize {
        let label = UILabel(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: maxWidth,
                                       height: .greatestFiniteMagnitude)))
        
        label.numberOfLines = 0
        
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.size
    }
}

extension UIFont {
    static func robotoRegular(size: CGFloat = 17) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: .regular)
        return UIFont(name: "Roboto-Regular", size: size) ?? systemFont
    }
    
    static func robotoBold(size: CGFloat = 17) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: .bold)
        return UIFont(name: "Roboto-Bold", size: size) ?? systemFont
    }
}

// MARK: - UIView
extension UIView {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func addFullConstraint() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
    
    func blink() {
        let oldColor = self.backgroundColor
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) { self.backgroundColor = oldColor }
        }
    }
}

// MARK: - UITableView
extension UITableView {
    
    func deqReusCell<T>(_ custClass: T.Type, indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: String(describing: custClass), for: indexPath) as? T
        else { return nil }
        return cell
    }
}

// MARK: - UICollectionView
extension UICollectionView {

    func deqReusCell<T>(_ custClass: T.Type, indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: String(describing: custClass), for: indexPath) as? T
        else { return nil }
        return cell
    }
}

// MARK: - UIStoryboard
extension UIStoryboard {
    
    class func controller<T>(_ custClass: T.Type) -> T? {
        let nameController = String(describing: custClass)
        
        let storyboard = UIStoryboard(name: nameController, bundle: nil)
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: nameController) as? T
        else { return nil }
        
        return controller
    }
}

// MARK: - UIApplication
extension UIApplication {
    
    static func currentController() -> UIViewController? {
        let keyWindow = self.shared.windows.filter { $0.isKeyWindow }
        if var topController = keyWindow.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}

// MARK: - Date
extension Date {
    
    var zodiacSign: ZodiacSign {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        
        switch (day, month) {
        case (21...31, 1), (1...19, 2):
            return .aquarius
        case (20...29, 2), (1...20, 3):
            return .pisces
        case (21...31, 3), (1...20, 4):
            return .aries
        case (21...30, 4), (1...21, 5):
            return .taurus
        case (22...31, 5), (1...21, 6):
            return .gemini
        case (22...30, 6), (1...22, 7):
            return .cancer
        case (23...31, 7), (1...22, 8):
            return .leo
        case (23...31, 8), (1...23, 9):
            return .virgo
        case (24...30, 9), (1...23, 10):
            return .libra
        case (24...31, 10), (1...22, 11):
            return .scorpio
        case (23...30, 11), (1...21, 12):
            return .sagittarius
        default:
            return .capricorn
        }
    }
}
