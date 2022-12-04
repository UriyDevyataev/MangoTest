//
//  LoaderView.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 04.12.2022.
//

import UIKit

class LoaderView: UIView {
    
    private var loader = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        alpha = 0
        backgroundColor = .black.withAlphaComponent(0.6)
        loader.color = .white
        
        addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func start(for view: UIView) {
        view.addSubview(self)
        addFullConstraint()
        
        loader.startAnimating()
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }    
}
