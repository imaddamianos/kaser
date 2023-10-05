//
//  ChatDetailsViewController.swift
//  kaser
//
//  Created by iMad on 03/10/2023.
//

import UIKit

class ChatDetailsViewController: UIViewController {

    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    var currentUser: usersStruct?
    var chatID: String = ""
    var messages: [MessageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.delegate = self
        chatView.dataSource = self
        chatView.register(ChatTableViewCell.nib, forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatView.reloadData()
//        self.title =
    }
    
    func sendMessageToFirebase(userType: String, messageText: String) {
        let messageData = [
           "senderID": currentUser?.UserName, // Replace with the actual user ID
            "message": messageText
        ]
        let currentUser = currentUser?.UserName
        let chatPath = "chats/\(chatID)/users/\(currentUser ?? "")"
        ref.child(userType).child(newID!).child(chatPath).setValue(messageData)
        
        // After successfully sending the message, add it to the local messages array
        let newMessage = MessageData(message: messageText, senderID: currentUser)
        messages.append(newMessage)
        
        // Reload the table view to reflect the new message
        chatView.reloadData()
    }

    
    // MARK: - Actions

    @IBAction func sendMessage(_ sender: UIButton) {
        if let messageText = messageTextField.text, !messageText.isEmpty {
            sendMessageToFirebase(userType: (currentUser?.userType)!, messageText: messageText)
            messageTextField.text = ""
        }
    }
}

extension ChatDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return messages.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { fatalError("xib doesn't exist") }
         let message = messages[indexPath.row]
         cell.textLbl.text = message.message
//         cell.textLabel?.text = message.senderID
//         cell.detailTextLabel?.text = message.message
         return cell
     }
}
