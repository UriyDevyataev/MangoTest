//
//  EditProfileViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 05.12.2022.
//

import Photos
import UIKit

enum ZodiacSign: String {
    case aries
    case taurus
    case gemini
    case cancer
    case leo
    case virgo
    case libra
    case scorpio
    case sagittarius
    case capricorn
    case aquarius
    case pisces
    
    var name: String {
        return rawValue.capitalized
    }
}

class EditProfileViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var editImageButton: UIButton!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    @IBOutlet private weak var nameInfoLabel: UILabel!
    @IBOutlet private weak var birthdayInfoLabel: UILabel!
    @IBOutlet private weak var zodiacInfoLabel: UILabel!
    @IBOutlet private weak var cityInfoLabel: UILabel!
    @IBOutlet private weak var vkInfoLabel: UILabel!
    @IBOutlet private weak var instagramInfoLabel: UILabel!
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var zodiacLabel: UILabel!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var vkTextField: UITextField!
    @IBOutlet private weak var instagramTextField: UITextField!
    
    @IBOutlet private weak var aboutInfoLabel: UILabel!
    @IBOutlet private weak var aboutTextView: UITextView!
    
    private var imagePicker = UIImagePickerController()
    
    private let loader = LoaderView()
    
    private let user = User.shared
    
    private var activeInputText: UIView?
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        config()
        addObserver()
        addGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    // MARK: - Configuration
    
    private func config() {
        configNavigationBar()
        configScrollView()
        configProfileImage()
        configLabels()
        configTextFields()
        
        configImagePicker()
        configDatePicker()
        
        setContent()
    }
    
    func configNavigationBar() {
        let cancelButton = UIBarButtonItem(
            title: "cancel".localized,
            style: .done,
            target: self,
            action: #selector(actionCancel))
        
        let saveButton = UIBarButtonItem(
            title: "save".localized,
            style: .done,
            target: self,
            action: #selector(actionSave))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configScrollView() {
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInset.bottom = 10
    }
    
    private func configProfileImage() {
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .lightGray
        profileImage.layer.borderColor = UIColor.link.cgColor
        profileImage.layer.borderWidth = 3
        
        editImageButton.setTitle("", for: .normal)
        editImageButton.backgroundColor = .clear
    }
    
    private func configLabels() {
        usernameLabel.font = UIFont.robotoRegular(size: 25)
        phoneLabel.font = UIFont.robotoRegular(size: 22)
        
        nameInfoLabel.font = UIFont.robotoRegular()
        birthdayInfoLabel.font = UIFont.robotoRegular()
        zodiacInfoLabel.font = UIFont.robotoRegular()
        cityInfoLabel.font = UIFont.robotoRegular()
        vkInfoLabel.font = UIFont.robotoRegular()
        instagramInfoLabel.font = UIFont.robotoRegular()
        aboutInfoLabel.font = UIFont.robotoRegular()
        
        zodiacLabel.font = UIFont.robotoRegular(size: 22)
        
        nameInfoLabel.text = "name_info".localized
        birthdayInfoLabel.text = "birthday_info".localized
        zodiacInfoLabel.text = "zodiac_info".localized
        cityInfoLabel.text = "city_info".localized
        vkInfoLabel.text = "vk_info".localized
        instagramInfoLabel.text = "instagram_info".localized
        aboutInfoLabel.text = "about_info".localized
    }
    
    private func configTextFields() {
        nameTextField.font = UIFont.robotoRegular(size: 22)
        cityTextField.font = UIFont.robotoRegular(size: 22)
        vkTextField.font = UIFont.robotoRegular(size: 22)
        instagramTextField.font = UIFont.robotoRegular(size: 22)
        aboutTextView.font = UIFont.robotoRegular(size: 22)
        
        aboutTextView.layer.cornerRadius = 5
        aboutTextView.layer.borderWidth = 1.5
        aboutTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        
        nameTextField.delegate = self
        cityTextField.delegate = self
        vkTextField.delegate = self
        instagramTextField.delegate = self
        aboutTextView.delegate = self
    }
    
    private func configImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    private func configDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        if let birthday = user.birthday,
           let date = formatter.date(from: birthday) {
            datePicker.date = date
        }
    }
    
    private func setContent() {
        phoneLabel.text = "+\(user.phone ?? "")"
        usernameLabel.text = user.username
        
        nameTextField.text = user.name
        zodiacLabel.text = user.zodiac
        cityTextField.text = user.city
        vkTextField.text = user.vk
        instagramTextField.text = user.instagram
        
        aboutTextView.text = user.about
        
        setImage()
    }
    
    private func setImage() {
        if let avatar = user.avatar,
           let imageData = Data(base64Encoded: avatar) {
            profileImage.image = UIImage(data: imageData)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionEditImage(_ sender: UIButton) {
        PhotoAuthHelper.photoLibraryAuth { result in
            if !result {
                AlertHelper.presentOpenSettingsAlert()
                return
            }
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func dateChanged() {
        zodiacLabel.text = datePicker.date.zodiacSign.name
    }
    
    @objc
    private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func actionSave() {
        if !isValidData() { return }
        
        if !NetworkChecker.isConnected() {
            AlertHelper.showNoInternetAlert()
            return
        }
        
        view.endEditing(true)
        loader.start()
        
        User.shared.name = nameTextField.text
        User.shared.birthday = formatter.string(from: datePicker.date)
        User.shared.city = cityTextField.text == "" ? nil : cityTextField.text
        User.shared.vk = vkTextField.text == "" ? nil : vkTextField.text
        User.shared.instagram = instagramTextField.text == "" ? nil : instagramTextField.text
        User.shared.avatar = profileImage.image?.pngData()?.base64EncodedString()
        User.shared.zodiac = zodiacLabel.text == "" ? nil : zodiacLabel.text
        User.shared.about = aboutTextView.text == "" ? nil : aboutTextView.text
        
        user.save { result in
            DispatchQueue.main.async {
                self.loader.stop()
                if !result { return }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func isValidData() -> Bool {
        let nameIsValid = nameTextField.text != ""
        
        if !nameIsValid {
            nameTextField.blink()
        }
        
        return nameIsValid
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeInputText = textField
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeInputText = textView
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileViewController
extension EditProfileViewController {
    
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
        
        guard let activeInputText = activeInputText else { return }
        let rect = activeInputText.convert(activeInputText.bounds, to: view)
        
        let offset = rect.maxY - keyBoard.cgRectValue.minY + 20

        if offset < 0 { return }
        scrollView.contentInset.bottom = offset
        scrollView.scrollToBottom(animated: true)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentInset.bottom = 10
    }
}

// MARK: - Add Gesture
extension EditProfileViewController {

    func addGesture() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
