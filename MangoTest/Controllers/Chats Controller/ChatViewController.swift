//
//  ChatViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 11.12.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var textViewContainer: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // constraints
    @IBOutlet private weak var heighTextView: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraintTextView: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraintTextContainer: NSLayoutConstraint!
    
    private var standartHeighTabBr: CGFloat {
        tabBarController?.tabBar.frame.height ?? 80
    }
    
    private var standartHeighTextView: CGFloat = 40
    
    private var dataSource = [MockMessage]()
    
    var chat: MockChat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        createDataSource()
        config()
        addObserver()
        addGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrolToBottom()
    }
    
    private func createDataSource() {
        guard let chat = chat else { return }
        dataSource = chat.messages
    }
    
    private func config() {
        configCollectionView()
        configTextContainer()
    }
    
    private func configCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 20
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.register(
            MessageCollectionViewCell.self,
            forCellWithReuseIdentifier: MessageCollectionViewCell.identifier)
    }
    
    private func configTextContainer() {
        textViewContainer.backgroundColor = .black.withAlphaComponent(0.6)
        
        textView.font = UIFont.robotoRegular(size: 22)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = textView.frame.height * 0.5
        textView.contentInset.left = 10
        textView.delegate = self
        
        bottomConstraintTextView.constant = standartHeighTabBr - standartHeighTextView - 10
        
        sendButton.setTitle("", for: .normal)
        sendButton.setImage(.init(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .white
    }
    
    private func updateSizeTextView() {
        let newHeight = textView.text.sizeInTextView(font: textView.font).height
        if newHeight > 100 { return }
        heighTextView.constant = newHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        sendButton.isEnabled = textView.text != ""
    }
    
    @IBAction func actionSend(_ sender: UIButton) {
        
        let message = MockMessage(text: textView.text, date: Date(), isMy: true)
        dataSource.append(message)
        collectionView.reloadData()
        
        textView.text = ""
        scrolToBottom()
    }
    
    private func scrolToBottom() {
        collectionView.scrollToItem(
            at: IndexPath(row: dataSource.count - 1, section: 0),
            at: .bottom,
            animated: true)
    }
    
    private func calculateHeighCell(indexPath: IndexPath) -> CGFloat {
        let topPaddingCell: CGFloat = 10
        let bottomPaddingCell: CGFloat = 5
        let dateLabelHeight: CGFloat = 30
        
        let maxWidth = collectionView.frame.width * 0.9
        let text = dataSource[indexPath.row].text
        let size = text.size(font: UIFont.robotoRegular(), maxWidth: maxWidth)
        
        return topPaddingCell + size.height + dateLabelHeight + bottomPaddingCell
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.deqReusCell(
            MessageCollectionViewCell.self, indexPath: indexPath)
        else { return UICollectionViewCell() }
        
        let message = dataSource[indexPath.row]
        
        cell.setCell(text: message.text, date: message.date, isMy: message.isMy)
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegate {
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: calculateHeighCell(indexPath: indexPath))
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateSizeTextView()
    }
}

// MARK: - EditProfileViewController
extension ChatViewController {
    
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
        
        let rect = textView.convert(textView.bounds, to: view)
        let offset = rect.maxY - keyBoard.cgRectValue.minY + 10
        
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .init(translationX: 0, y: -offset)
        }
        
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = .identity
        }
    }
}

// MARK: - Add Gesture
extension ChatViewController {
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
