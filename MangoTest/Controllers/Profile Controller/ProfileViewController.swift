//
//  ProfileViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 05.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    @IBOutlet private weak var nameInfoLabel: UILabel!
    @IBOutlet private weak var birthdayInfoLabel: UILabel!
    @IBOutlet private weak var zodiacInfoLabel: UILabel!
    @IBOutlet private weak var cityInfoLabel: UILabel!
    @IBOutlet private weak var vkInfoLabel: UILabel!
    @IBOutlet private weak var instagramInfoLabel: UILabel!
    @IBOutlet private weak var aboutInfoLabel: UILabel!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var zodiacLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var vkLabel: UILabel!
    @IBOutlet private weak var instagramLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    
    @IBOutlet private weak var createdLabel: UILabel!
    
    private let user = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContent()
    }
    
    // MARK: - Configuration
    
    private func config() {
        view.backgroundColor = .white
        configNavigationBar()
        configProfileImage()
        configLabels()
    }
    
    func configNavigationBar() {        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .done,
            target: self,
            action: #selector(actionEdit))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func configProfileImage() {
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .lightGray
        profileImage.layer.borderColor = UIColor.link.cgColor
        profileImage.layer.borderWidth = 3
    }
    
    private func configLabels() {
        usernameLabel.font = UIFont.robotoBold(size: 25)
        phoneLabel.font = UIFont.robotoRegular(size: 22)
        
        nameInfoLabel.font = UIFont.robotoRegular()
        birthdayInfoLabel.font = UIFont.robotoRegular()
        zodiacInfoLabel.font = UIFont.robotoRegular()
        cityInfoLabel.font = UIFont.robotoRegular()
        vkInfoLabel.font = UIFont.robotoRegular()
        instagramInfoLabel.font = UIFont.robotoRegular()
        aboutInfoLabel.font = UIFont.robotoRegular()
        
        nameLabel.font = UIFont.robotoRegular(size: 22)
        birthdayLabel.font = UIFont.robotoRegular(size: 22)
        zodiacLabel.font = UIFont.robotoRegular(size: 22)
        cityLabel.font = UIFont.robotoRegular(size: 22)
        vkLabel.font = UIFont.robotoRegular(size: 22)
        instagramLabel.font = UIFont.robotoRegular(size: 22)
        aboutLabel.font = UIFont.robotoRegular(size: 22)
        
        createdLabel.font = UIFont.robotoRegular()
        createdLabel.textColor = .lightGray
        
        nameInfoLabel.text = "name_info".localized
        birthdayInfoLabel.text = "birthday_info".localized
        zodiacInfoLabel.text = "zodiac_info".localized
        cityInfoLabel.text = "city_info".localized
        vkInfoLabel.text = "vk_info".localized
        instagramInfoLabel.text = "instagram_info".localized
        aboutInfoLabel.text = "about_info".localized
    }
    
    private func setContent() {
        phoneLabel.text = user.phone
        usernameLabel.text = user.username
        
        nameLabel.text = user.name
        birthdayLabel.text = user.birthday
        zodiacLabel.text = user.zodiac
        cityLabel.text = user.city
        vkLabel.text = user.vk
        instagramLabel.text = user.instagram
        aboutLabel.text = user.about
        
        birthdayInfoLabel.isHidden = user.birthday == nil
        zodiacInfoLabel.isHidden = user.zodiac == nil
        cityInfoLabel.isHidden = user.city == nil
        vkInfoLabel.isHidden = user.vk == nil
        instagramInfoLabel.isHidden = user.instagram == nil
        aboutInfoLabel.isHidden = user.about == nil
        
        birthdayLabel.isHidden = user.birthday == nil
        zodiacLabel.isHidden = user.zodiac == nil
        cityLabel.isHidden = user.city == nil
        vkLabel.isHidden = user.vk == nil
        instagramLabel.isHidden = user.instagram == nil
        aboutLabel.isHidden = user.about == nil
        
        setImage()
        setCreatedInfo()
    }
    
    private func setImage() {
        if let avatar = user.avatar,
           let imageData = Data(base64Encoded: avatar) {
            profileImage.image = UIImage(data: imageData)
        }
    }
    
    private func setCreatedInfo() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let created = user.created,
           let date = formatter.date(from: created) {
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateStr = formatter.string(from: date)
            createdLabel.text = String(format: "registered".localized, dateStr)
        } else {
            createdLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func actionEdit() {
        showEditController()
    }
    
    private func showEditController() {
        guard let controller = UIStoryboard.controller(EditProfileViewController.self)
        else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
}
