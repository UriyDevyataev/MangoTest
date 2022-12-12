//
//  TabBarController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 05.12.2022.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case chats
    case profile
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !NetworkChecker.isConnected() {
            AlertHelper.showNoInternetAlert()
            return
        }
    }

    private func setupUI() {        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .lightGray.withAlphaComponent(0.5)
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }

    private func setupVC() {
        let dataSource: [TabBarItem] = TabBarItem.allCases
        var array = [UIViewController]()

        dataSource.forEach { item in
            var navVC: UINavigationController?

            switch item {
            case .chats: navVC = createChatsController()
            case .profile: navVC = createProfileController()
            }

            navVC?.interactivePopGestureRecognizer?.delegate = self

            guard let navVC = navVC else { return }
            array.append(navVC)
        }
        viewControllers = array
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TabBarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension TabBarController {
    
    func createChatsController() -> UINavigationController? {
        guard let controller = UIStoryboard.controller(ChatsViewController.self)
        else { return nil }
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message"))
        
        return navVC
    }
    
    func createProfileController() -> UINavigationController? {
        guard let controller = UIStoryboard.controller(ProfileViewController.self)
        else { return nil }
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle"))
        return navVC
    }
}
