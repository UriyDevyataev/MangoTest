//
//  ChatsViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 05.12.2022.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource = [MockChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = MockData.shared.chats
        
        configNavigationBar()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Configuration

    private func configNavigationBar() {
        title = "chats".localized
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false

        tableView.register(
            ChatTableViewCell.self,
            forCellReuseIdentifier: ChatTableViewCell.identifier)
    }
    
    private func toChatController(index chat: Int) {
        guard let controller = UIStoryboard.controller(ChatViewController.self)
        else { return }
        controller.chat = dataSource[chat]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.deqReusCell(ChatTableViewCell.self, indexPath: indexPath)
        else { return UITableViewCell() }

        let chat = dataSource[indexPath.row]
        
        cell.setCell(
            name: chat.user.name,
            lastMessage: chat.messages.last?.text,
            avatar: chat.user.avatar,
            date: chat.messages.last?.date)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toChatController(index: indexPath.row)
    }
}
