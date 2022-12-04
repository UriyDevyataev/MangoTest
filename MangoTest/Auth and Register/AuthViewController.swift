//
//  AuthViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import PhoneNumberKit
import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var placeHolderTextField: UITextField!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var countruButton: UIButton!
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    
    var selectedCountry: Country?
    var inputNumber: String = ""
    
    private let countryService = CountryServiceImp.shared
    private let networkService = NetworkServiceImp()
    
    private let loader = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCurrentCountry()
        config()
        updateContent()
        addObserver()
    }
    
    // MARK: - Configuration
    
    private func config() {
        configInfoLabel()
        configTextFields()
        configCountryButton()
        configPlaceHolder()
        configContinueButton()
    }
    
    private func configInfoLabel() {
        infoLabel.numberOfLines = 0
        infoLabel.text = "auth_info_send".localized
    }
    
    private func configTextFields() {
        codeTextField.borderStyle = .none
        phoneTextField.borderStyle = .none
        placeHolderTextField.borderStyle = .none
        
        codeTextField.keyboardType = .numberPad
        phoneTextField.keyboardType = .numberPad
        
        codeTextField.delegate = self
        phoneTextField.delegate = self
        
        codeTextField.textAlignment = .center
        phoneTextField.becomeFirstResponder()
        placeHolderTextField.isEnabled = false
    }
    
    @objc
    private func configPlaceHolder(for inputText: String = "") {
        guard
            let country = selectedCountry,
            let example = PhoneNumberKit().metadata(for: country.region)?.mobile?.exampleNumber
        else { return }
        
        var placeholder = ""
        for _ in 0...example.count - 1 {
            placeholder += "0"
        }
        
        let maxIndex = placeholder.index(placeholder.startIndex, offsetBy: placeholder.count)
        let range = placeholder.startIndex..<maxIndex
        
        let pattern = "(\\d{3})(\\d{3})(\\d+)"
        
        placeholder = placeholder.replacingOccurrences(
            of: pattern,
            with: "$1 $2 $3",
            options: .regularExpression,
            range: range)
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.foregroundColor] = UIColor.gray
        
        let attrPlaceholder = NSMutableAttributedString(string: placeholder, attributes: attributes)
        
        if inputText.count >= placeholder.count {
            placeHolderTextField.attributedText = NSMutableAttributedString(
                string: "", attributes: attributes)
            return
        }
        
        var attributesClear = [NSAttributedString.Key: Any]()
        attributesClear[.foregroundColor] = UIColor.clear.cgColor
        
        let rangeClear = NSRange(location: 0, length: inputText.count)
        attrPlaceholder.addAttributes(attributesClear, range: rangeClear)
        
        placeHolderTextField.attributedText = attrPlaceholder
    }
    
    private func configCountryButton() {
        guard let country = selectedCountry else {
            countruButton.setTitle("country".localized, for: .normal)
            return
        }
        let flagEmoji = flag(for: country.region)
        let title = "\(flagEmoji) \(country.name)"
        countruButton.setTitle(title, for: .normal)
    }
    
    private func configContinueButton() {
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.backgroundColor = .lightGray
        continueButton.tintColor = .white
        continueButton.layer.cornerRadius = 8
        continueButton.isEnabled = false
    }
    
    private func checkCurrentCountry() {
        guard let region = Locale.current.regionCode,
              let country = Locale.current.localizedString(forRegionCode: region),
              let code = countryPrefixes[region]
        else { return }
        
        selectedCountry = Country(region: region, name: country, code: code)
    }
    
    private func flag(for country: String) -> String {
        let base: UInt32 = 127397
        var string = ""
        for item in country.uppercased().unicodeScalars {
            string.unicodeScalars.append(UnicodeScalar(base + item.value) ?? UnicodeScalar(0))
        }
        return string
    }
    
    private func updateContent() {
        configCountryButton()
        
        if selectedCountry != nil {
            codeTextField.text = "+\(selectedCountry?.code ?? "")"
            phoneTextField.isEnabled = true
            phoneTextField.text = ""
            phoneTextField.becomeFirstResponder()
        } else {
            phoneTextField.isEnabled = false
            continueButton.isEnabled = false
            continueButton.backgroundColor = .lightGray
        }
        
        configPlaceHolder()
    }
    
    // MARK: - Show Controllers
    
    private func showSelectCountryController() {
        guard let controller = UIStoryboard.controller(SelectCountryViewController.self)
        else { return }
        controller.delegate = self
        
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    private func showCheckCodeController() {
        guard let controller = UIStoryboard.controller(CheckCodeViewController.self)
        else { return }
        
        controller.inputNumber = inputNumber
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func countryAction(_ sender: UIButton) {
        showSelectCountryController()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        view.endEditing(true)
        loader.start(for: view)
        sendPhoneNumber()
    }
    
    // MARK: - Formatting Text Fields
    
    func format(phoneNumber: String) -> String {
        var number = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<maxIndex
        
        var pattern = "(\\d{3})(\\d+)"
        var counted = "$1 $2"
        
        if number.count > 6 {
            pattern = "(\\d{3})(\\d{3})(\\d+)"
            counted = "$1 $2 $3"
        }
        
        number = number.replacingOccurrences(
            of: pattern,
            with: counted,
            options: .regularExpression,
            range: range)
        
        return number
    }
    
    private func checkCountry(for code: String) {
        let number = code.replacingOccurrences(of: "+", with: "")
        selectedCountry = countryService.country(for: number)
        updateContent()
    }
}

// MARK: - SelectCountryViewControllerDelegate
extension AuthViewController: SelectCountryViewControllerDelegate {
    
    func selectedCountry(_ country: Country, sender: SelectCountryViewController) {
        DispatchQueue.main.async {
            self.selectedCountry = country
            self.updateContent()
        }
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        var text: String = (textField.text ?? "") + string
        if range.length == 1 { text.removeLast() }
        
        switch textField {
        case codeTextField:
            if text == "" { return false }
            textField.text = text
            checkCountry(for: text)
        case phoneTextField:
            let number = format(phoneNumber: text)
            configPlaceHolder(for: number)
            textField.text = number
            
            continueButton.isEnabled = text.count > 3
            continueButton.backgroundColor = text.count > 3 ? .link : .lightGray
        default: break
        }
        return false
    }
}

// MARK: - Network
extension AuthViewController {
    
    func sendPhoneNumber() {
        guard
            let code = codeTextField.text,
            let numberStr = phoneTextField.text
        else { return }
        
        let numberDigit = numberStr.replacingOccurrences(of: " ", with: "")
        inputNumber = code + numberDigit
        
        networkService.getAuthCode(for: inputNumber) { result in
            DispatchQueue.main.async {
                self.responseProcessing(result)
            }
        }
    }
    
    private func responseProcessing(_ result: Result<Bool, Error>) {
        self.loader.stop()
        switch result {
        case let .success(res):
            
            if res {
                self.showCheckCodeController()
                return
            }
            
            let error = NSError(domain: "try_later".localized, code: 404, userInfo: nil)
            AlertHelper.showErrorAuthAlert(error)
            
        case let .failure(error):
            AlertHelper.showErrorAuthAlert(error)
        }
    }
}


// MARK: - Add observers
extension AuthViewController {
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyBoardWillHide),
            name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyBoard: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue
        else { return }
        
        let offset = contentView.frame.maxY - keyBoard.cgRectValue.minY + 20
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
        }
    }
    
    @objc
    func keyBoardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
        }
    }
}
