//
//  MockChats.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 11.12.2022.
//

// swiftlint: disable identifier_name

import Foundation
import UIKit

struct MockChat {
    let user: MockUser
    let messages: [MockMessage]
}

struct MockUser {
    let name: String
    let avatar: UIImage?
}

struct MockMessage {
    let text: String
    let date: Date
    let isMy: Bool
}

final class MockData {
    
    static let shared = MockData()
    
    var chats = [MockChat]()
    
    init() {
        let user1 = MockUser(name: "Govard", avatar: UIImage(named: "pic1.jpg"))
        let user2 = MockUser(name: "Stan", avatar: UIImage(named: "pic2.jpg"))
        let user3 = MockUser(name: "Maveric", avatar: UIImage(named: "pic3.jpg"))
        let user4 = MockUser(name: "Lui", avatar: UIImage(named: "pic4.jpg"))
        let user5 = MockUser(name: "Atros", avatar: UIImage(named: "pic5.jpg"))
        let user6 = MockUser(name: "Timmy", avatar: UIImage(named: "pic6.jpg"))
        let user7 = MockUser(name: "Luisa", avatar: UIImage(named: "pic7.jpg"))
        let user8 = MockUser(name: "Emily", avatar: UIImage(named: "pic8.jpg"))
        let user9 = MockUser(name: "Bred", avatar: UIImage(named: "pic9.jpg"))
        let user10 = MockUser(name: "Mike", avatar: UIImage(named: "pic10.jpg"))
        let user11 = MockUser(name: "Terry", avatar: UIImage(named: "pic11.jpg"))
        let user12 = MockUser(name: "Bak", avatar: UIImage(named: "pic12.jpg"))
        let user13 = MockUser(name: "Melissa", avatar: UIImage(named: "pic13.jpg"))
        
        let users = [user1, user2, user3, user4, user5,
                     user6, user7, user8, user9, user10,
                     user11, user12, user13]
        
        let textArray = mockText.components(separatedBy: ".")
                
        var date = Date()
        var messages = [MockMessage]()
        
        for (index, text) in textArray.enumerated() {
            let message = MockMessage(text: text, date: date, isMy: index % 2 == 0)
            messages.append(message)
            date = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? Date()
        }
        
        for (index, user) in users.enumerated() {
            var messagesInChat = [MockMessage]()
            for indexMes in (index * 5..<5 * (index + 1)) {
                messagesInChat.append(messages[indexMes])
            }
            
            let chat = MockChat(user: user, messages: messagesInChat)
            chats.append(chat)
        }
    }
}
