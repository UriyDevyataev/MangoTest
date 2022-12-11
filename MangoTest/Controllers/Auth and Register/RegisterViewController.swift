//
//  RegisterViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 04.12.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    
    private let loader = LoaderView()
    
    private let networkService = NetworkServiceImp.shared
        
    var inputNumber: String = ""
    private var name: String = ""
    private var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        addObserver()
    }
    
    private func config() {
        configLabels()
        configTextFields()
        configContinueButton()
    }
    
    private func configLabels() {
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.text = "register".localized
        
        numberLabel.textAlignment = .center
        numberLabel.text = inputNumber
    }
    
    private func configTextFields() {
        nameTextField.borderStyle = .none
        usernameTextField.borderStyle = .none
        
        nameTextField.textAlignment = .center
        usernameTextField.textAlignment = .center
        
        nameTextField.placeholder = "name_placeholder".localized
        usernameTextField.placeholder = "username_placeholder".localized
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        
        nameTextField.becomeFirstResponder()
    }
    
    private func configContinueButton() {
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.backgroundColor = .lightGray
        continueButton.tintColor = .white
        continueButton.layer.cornerRadius = 8
        continueButton.isEnabled = false
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        view.endEditing(true)
        
        if !NetworkChecker.isConnected() { return }
        loader.start()
        registration()
    }
    
    func isValidUserName(_ input: String) -> Bool {
        let regex = "^([a-zA-Z0-9_-])+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
    }
    
    private func checkEnabledContinue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let name = self.nameTextField.text,
                  let username = self.usernameTextField.text,
                  !(name.isEmpty && username.isEmpty)
            else {
                self.continueButton.isEnabled = false
                self.continueButton.backgroundColor = .lightGray
                return
            }
            
            self.name = name
            self.username = username
            
            self.continueButton.isEnabled = true
            self.continueButton.backgroundColor = .link
        }
    }
    
    private func showMainScreen() {
        DispatchQueue.main.async {
            let controller = TabBarController()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = controller
        }
    }
}

extension RegisterViewController {
    
    private func registration() {
        
        guard
            !inputNumber.isEmpty,
            !name.isEmpty,
            !username.isEmpty
        else { return }
                
        networkService.registration(for: inputNumber,
                                       name: name,
                                       username: username) { result in
            switch result {
            case let .success(model):
                User.shared.accessToken = model.access_token
                User.shared.refreshToken = model.refresh_token
                User.shared.saveLocal()
                self.getMe()
            case let .failure(error):
                AlertHelper.showErrorAlert(error)
            }
        }
    }
    
    private func getMe() {
        networkService.getMe(User.shared.accessToken ?? "") { result in
            self.loader.stop()
            
            switch result {
            case let .success(model):
                User.shared.name = model.profile_data.name
                User.shared.username = model.profile_data.username
                User.shared.birthday = model.profile_data.birthday
                User.shared.city = model.profile_data.city
                User.shared.vk = model.profile_data.vk
                User.shared.instagram = model.profile_data.instagram
                User.shared.status = model.profile_data.status
                User.shared.avatar = model.profile_data.avatar
                User.shared.id = model.profile_data.id
                User.shared.created = model.profile_data.created
                User.shared.phone = model.profile_data.phone
                
                User.shared.saveLocal()
                
                DispatchQueue.main.async {
                    self.showMainScreen()
                }
            case let .failure(error):
                AlertHelper.showErrorAlert(error)
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        checkEnabledContinue()
        
        if textField == usernameTextField, string != "" {
            return isValidUserName(string)
        }
        
        return true
    }
}

extension RegisterViewController {
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyBoard: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue
        else { return }
        
        let offset = contentView.frame.maxY - keyBoard.cgRectValue.minY + 20
        
        if offset < 0 { return }
                
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
        }
    }
}
