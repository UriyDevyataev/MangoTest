//
//  Extensions.swift
//  RelationshipMediator
//
//  Created by yurii.devyataev on 10.08.2022.
//

import Foundation
import UIKit

// MARK: - UIColor
//extension UIColor {
//
//    convenience init(hexString: String, with opacity: CGFloat = 1) {
//        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int = UInt64()
//        Scanner(string: hex).scanHexInt64(&int)
//        let red, green, blue: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (red, green, blue) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (red, green, blue) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (red, green, blue) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (red, green, blue) = (0, 0, 0)
//        }
//        self.init(red: CGFloat(red) / 255,
//                  green: CGFloat(green) / 255,
//                  blue: CGFloat(blue) / 255,
//                  alpha: opacity)
//    }
//}
//
// MARK: - String
//extension String {
//
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//
//    func getSize(font: UIFont) -> CGSize {
//        let label = UILabel(frame: .zero)
//        label.numberOfLines = 0
//        label.font = font
//        label.text = self
//        label.sizeToFit()
//        return label.frame.size
//    }
//
//    func capitalizingFirstLetter() -> String {
//        return prefix(1).capitalized + dropFirst()
//    }
//}
//
// MARK: - UINavigationBar
//extension UINavigationBar {
//
//    func configNavigationBar(color: UIColor = Color.backGrayColor, with sizeTitle: CGFloat = .zero) {
//        var attributes = [NSAttributedString.Key: Any]()
//        attributes[.font] = CustomFont.notoSansDisplayBold(size: sizeTitle)
//        attributes[.foregroundColor] = UIColor.black
//
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = color
//        appearance.shadowColor = .clear
//        appearance.titleTextAttributes = attributes
//
//        self.standardAppearance = appearance
//        self.scrollEdgeAppearance = appearance
//        self.tintColor = .black
//    }
//
//    func setLeftTitle(with text: String, size: CGFloat, navigationItem: UINavigationItem) {
//        let button = UIButton()
//        button.contentEdgeInsets.left = 8
//
//        var attributes = [NSAttributedString.Key: Any]()
//        attributes[.font] = CustomFont.notoSansDisplayBold(size: size)
//        attributes[.foregroundColor] = UIColor.black
//        let attrTitle = NSMutableAttributedString(string: text, attributes: attributes)
//        button.setAttributedTitle(attrTitle, for: .normal)
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
//    }
//}
//
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
}
//
// MARK: - UITableView
//extension UITableView {
//
//    func deqReusCell<T>(_ custClass: T.Type, indexPath: IndexPath) -> T? {
//        guard let cell = self.dequeueReusableCell(
//            withIdentifier: String(describing: custClass), for: indexPath) as? T
//        else { return nil }
//        return cell
//    }
//}
//
// MARK: - UICollectionView
//extension UICollectionView {
//
//    func deqReusCell<T>(_ custClass: T.Type, indexPath: IndexPath) -> T? {
//        guard let cell = self.dequeueReusableCell(
//            withReuseIdentifier: String(describing: custClass), for: indexPath) as? T
//        else { return nil }
//        return cell
//    }
//}
//
// MARK: - UIStoryboard
//extension UIStoryboard {
//
//    class func controller<T>(_ custClass: T.Type) -> T? {
//        let nameController = String(describing: custClass)
//
//        let storyboard = UIStoryboard(name: nameController, bundle: nil)
//        guard let controller = storyboard.instantiateViewController(
//            withIdentifier: nameController) as? T
//        else { return nil }
//
//        return controller
//    }
//}
//
// MARK: - UITextField
//extension UITextField {
//
//    func setLeftPadding(_ amount: CGFloat = 5) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//    }
//
//    func setRightPadding(_ amount: CGFloat = 5) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
//}
//
// MARK: - Bundle
//extension Bundle {
//
//    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
//        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
//            return view
//        }
//        fatalError("Could not load view with type " + String(describing: type))
//    }
//}
//
// MARK: - UIViewController
//extension UIViewController {
//
//    func transitionVc(controller: UIViewController,
//                      duration: CFTimeInterval,
//                      type: CATransitionSubtype,
//                      completion: @escaping () -> Void) {
//        let transition = CATransition()
//        transition.duration = duration
//        transition.type = CATransitionType.push
//        transition.subtype = type
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        view.window?.layer.add(transition, forKey: kCATransition)
//        present(controller, animated: false) {
//            completion()
//        }
//
//    }
//
//    func setPremiumButton() {
//        let premiumButton = PremiumButton()
//        let premiumBurButton = UIBarButtonItem(customView: premiumButton)
//        if navigationItem.rightBarButtonItems == nil { navigationItem.rightBarButtonItems = [] }
//        navigationItem.rightBarButtonItems?.append(premiumBurButton)
//    }
//
//    func sendAnaliticGoToScreen() {
//        var toPlaceName = ""
//
//        switch self {
//        case is WelcomeViewController: toPlaceName = AmplitudeToPlaceName.welcome
//        case is FeelingsViewController: toPlaceName = AmplitudeToPlaceName.main
//        case is ProfileViewController: toPlaceName = AmplitudeToPlaceName.profile
//        case is MoodColorViewController: toPlaceName = AmplitudeToPlaceName.moodColor
//        case is StickersViewController: toPlaceName = AmplitudeToPlaceName.stickers
//        case is EmotionViewController: toPlaceName = AmplitudeToPlaceName.emotions
//        case is ImpressionViewController: toPlaceName = AmplitudeToPlaceName.impressions
//        case is EditMoodColorViewController: toPlaceName = AmplitudeToPlaceName.testResultEditing
//        case is EditEmotionViewController: toPlaceName = AmplitudeToPlaceName.emotionEditing
//        case is MagazineViewController: toPlaceName = AmplitudeToPlaceName.calendar
//        default: break
//        }
//
//        var properties = [String: Any]()
//        properties[AmplitudePropertyKey.name] = toPlaceName
//        AmplitudeHelper.shared.logEvent(.goToScreen, withEventProperties: properties)
//    }
//}
//
// MARK: - UIApplication
//extension UIApplication {
//
//    static func currentController() -> UIViewController? {
//        let keyWindow = self.shared.windows.filter { $0.isKeyWindow }
//        if var topController = keyWindow.first?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            return topController
//        }
//        return nil
//    }
//
//    var topSafeAreaInset: CGFloat? {
//        let window = UIApplication.shared.windows.first
//        let topPadding = window?.safeAreaInsets.top
//        return topPadding
//    }
//
//    var bottomSafeAreaInset: CGFloat? {
//        let window = UIApplication.shared.windows.first
//        let bottomPadding = window?.safeAreaInsets.bottom
//        return bottomPadding
//    }
//}
//
// MARK: - UIScrollView
//extension UIScrollView {
//
//    func scrollToBottom(animated: Bool) {
//        if self.contentSize.height < self.bounds.height { return }
//        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height)
//        self.setContentOffset(bottomOffset, animated: animated)
//    }
//
//    func scrollToTop(animated: Bool) {
//        self.setContentOffset(.zero, animated: animated)
//
//    }
//}


//extension UILabel {
//    func config(with font: UIFont, color: UIColor, aligment: NSTextAlignment = .left, numberLines: Int = 0) {
//        self.font = font
//        self.textColor = color
//        self.textAlignment = aligment
//        self.numberOfLines = numberLines
//    }
//}
