//
//  CheckCodeViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 04.12.2022.
//

import UIKit

class CheckCodeViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    
    private let loader = LoaderView()
    
    private let networkService = NetworkServiceImp.shared
    
    var inputNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        addObserver()
    }
    
    private func config() {
        configInfoLabel()
        configTextFields()
        configContinueButton()
    }
    
    private func configInfoLabel() {
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.text = "auth_info_check".localized
    }
    
    private func configTextFields() {
        codeTextField.borderStyle = .none
        codeTextField.keyboardType = .numberPad
        codeTextField.delegate = self
        codeTextField.textAlignment = .center
        codeTextField.becomeFirstResponder()
    }
    
    private func configContinueButton() {
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.backgroundColor = .lightGray
        continueButton.tintColor = .white
        continueButton.layer.cornerRadius = 8
        continueButton.isEnabled = false
    }
    
    @IBAction func continueAction(_ sender: Any) {
        view.endEditing(true)
        
        if !NetworkChecker.isConnected() {
            AlertHelper.showNoInternetAlert()
            return
        }
        
        loader.start()
        checkAuthCode()
    }
    
    private func showRegistrationController() {
        guard let controller = UIStoryboard.controller(RegisterViewController.self)
        else { return }

        controller.inputNumber = inputNumber
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
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

extension CheckCodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        var text: String = (textField.text ?? "") + string
        if range.length == 1 { text.removeLast() }
        
        if text.count > 6 { return false }
    
        textField.text = text
                
        continueButton.isEnabled = text.count == 6
        continueButton.backgroundColor = text.count == 6 ? .link : .lightGray
        
        return false
    }
}

extension CheckCodeViewController {
    
    func checkAuthCode() {
        guard
            !inputNumber.isEmpty,
            let code = codeTextField.text
        else { return }
        
        networkService.checkAuthCode(for: inputNumber, code: code) { result in
            self.loader.stop()
            
            switch result {
            case let .success(model):
                if model.is_user_exists {
                    User.shared.accessToken = model.access_token
                    User.shared.refreshToken = model.refresh_token
                    User.shared.saveLocal()
                    self.getMe()
                } else {
                    self.showRegistrationController()
                }
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
                User.shared.avatar = model.profile_data.avatar
            
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

extension CheckCodeViewController {
    
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
