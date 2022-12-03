//
//  RootViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import Lottie
import UIKit

class RootViewController: UIViewController {
    
    let gifContainer = UIView()
    var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addObserver()
        startApp()
    }
    
    private func startApp() {
        showLoader()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.toApp()
        }
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
