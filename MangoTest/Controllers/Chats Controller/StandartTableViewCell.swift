//
//  TableViewCell.swift
//  HandwritingPlannerAndCalendar
//
//  Created by yurii.devyataev on 02.12.2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    let avatarImage = UIImageView()
    let nameLabel = UILabel()
    let lastMessageLabel = UILabel()
    let dateLabel = UILabel()
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
        configConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        avatarImage.layer.cornerRadius = avatarImage.frame.height * 0.5
    }
    
    private func configCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.robotoBold()
        
        lastMessageLabel.textColor = .gray
        lastMessageLabel.textAlignment = .left
        lastMessageLabel.font = UIFont.robotoRegular()
        
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
//        avatarImage.layer.cornerRadius = avatarImage.frame.height * 0.5
        
        selectionStyle = .none
        
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(dateLabel)
    }
    
    func configConstraint() {
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        avatarImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5).isActive = true
        
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        lastMessageLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10).isActive = true
        lastMessageLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        dateLabel.setContentHuggingPriority(.init(rawValue: 1000), for: .horizontal)
    }
    
    func setCell(name: String, lastMessage: String?, avatar: UIImage?, date: Date?) {
        avatarImage.image = avatar
        nameLabel.text = name
        lastMessageLabel.text = lastMessage
        if let date = date {
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        layoutIfNeeded()
    }
}
