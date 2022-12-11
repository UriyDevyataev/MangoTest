//
//  RootViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import KeychainAccess
import Lottie
import UIKit

class RootViewController: UIViewController {
    
    private let gifContainer = UIView()
    private var animationView: AnimationView?
    private let networkService = NetworkServiceImp.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        showLoader()
        addObserver()
        checkAutorize()
    }
    
    private func showLoader() {
        view.addSubview(gifContainer)
        gifContainer.addFullConstraint()
        
        gifContainer.backgroundColor = .clear
        animationView = .init(name: "loader")
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1

        guard let animationView = animationView else { return }
        gifContainer.addSubview(animationView)
        animationView.addFullConstraint()
        animationView.play()
    }
    
    private func toApp() {
        DispatchQueue.main.async {
            let controller = TabBarController()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = controller
        }
    }
    
    private func toAutorize() {
        guard let controller = UIStoryboard.controller(AuthViewController.self) else { return }
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = navigationController
    }
    
    private func checkAutorize() {
        if !NetworkChecker.isConnected() { return }
        
        guard
            let accessToken = User.shared.accessToken,
            let refreshToken = User.shared.refreshToken
        else {
            toAutorize()
            return
        }
        
        networkService.refreshTokenIfNeeded(accessToken, refreshToken: refreshToken) { result in
            switch result {
            case let .success(model):
                User.shared.accessToken = model.access_token
                User.shared.refreshToken = model.refresh_token
                User.shared.saveLocal()
                self.toApp()
            case let .failure(error):
                AlertHelper.showErrorAlert(error)
            }
        }
    }
}

// MARK: - Observer
extension RootViewController {
    func addObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(didBecome),
            name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc
    func didBecome() {
        animationView?.play()
    }
}
