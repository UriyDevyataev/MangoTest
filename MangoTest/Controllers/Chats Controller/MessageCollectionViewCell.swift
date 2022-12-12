//
//  MessageCollectionViewCell.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 11.12.2022.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    let messageView = UIView()
     let textLabel = UILabel()
    private let dateLabel = UILabel()
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configCell() {
        backgroundColor = .clear
        
        messageView.layer.cornerRadius = 10
        
        textLabel.font = UIFont.robotoRegular()
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        
        dateLabel.font = UIFont.robotoRegular(size: 13)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .right
        
        addSubview(messageView)
        messageView.addSubview(textLabel)
        messageView.addSubview(dateLabel)
        
        configConstraint()
    }
    
    private func configConstraint() {
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        messageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9).isActive = true
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
        textLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5).isActive = true
    }
    
    func setCell(text: String, date: Date, isMy: Bool) {
        textLabel.text = text
        dateLabel.text = formatter.string(from: date)
        
        textLabel.textAlignment = isMy ? .right : .left
        
        leftConstraint?.isActive = false
        rightConstraint?.isActive = false

        leftConstraint = nil
        rightConstraint = nil
        
        let color: UIColor = isMy ? .blue : .black
        messageView.backgroundColor = color.withAlphaComponent(0.4)

        if isMy {
            rightConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
            rightConstraint?.isActive = true
        } else {
            leftConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
            leftConstraint?.isActive = true
        }
        
        layoutIfNeeded()
    }
}
