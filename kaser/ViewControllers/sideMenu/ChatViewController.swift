//
//  ChatViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController{

    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    struct Message {
        let senderID: String
        let messageText: String
    }
    
    var chatID: String = ""
    var currentUser: usersStruct?
    var messages: [MessageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChatTableViewCell.nib, forCellReuseIdentifier: ChatTableViewCell.identifier)
        
        // Initialize Firebase Database reference
        ref = Database.database().reference()
        APICalls.shared.getUserInfo(name: newEmail!){[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if !isSuccess { return }
            self?.currentUser = userDetails
            // Start observing chat messages
            StrongSelf.observeMessages(userType: (userDetails?.userType)!)
        }
        
        applyTheme(View: self) { backgroundColor in
            self.view.backgroundColor = backgroundColor
            
        // Update other UI elements here if needed
        }
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ChatDetailsNavId",
               let destinationVC = segue.destination as? ChatDetailsViewController {
                destinationVC.chatID = self.chatID
                destinationVC.currentUser = currentUser
                destinationVC.messages = self.messages
            }
        }


    func observeMessages(userType: String) {
        messageDetails.removeAll()
        
        ref.child(userType).child(newID!).child("chats/").observe(.childAdded) { snapshot in
            let roomName = snapshot.key
            self.chatID = roomName
            if let messageData = snapshot.value as? [String: Any] {
//                if let messages = messageData["messages"] as? Message {
//                    if let senderID = messages["senderID"] as? String,
//                       let messageText = messages["message"] as? String {
//                        let message = MessageData(message: messageText, senderID: self.chatID)
//                        self.messages.append(message)
//                        self.tableView.reloadData()
//                        self.performSegue(withIdentifier: "ChatDetailsNavId", sender: self)
//                    }
//                }
            }
            
            messageDetails.append(roomName)
            self.tableView.reloadData()
        }
    }
    
    @objc func chatCellTapped(_ sender: UITapGestureRecognizer) {
        // Handle cell tap here
        if let cell = sender.view as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let store = messageDetails[indexPath.row]
                self.performSegue(withIdentifier: "ChatDetailsNavId", sender: self)
                
            }
        }
    }
    
 }

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return messageDetails.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { fatalError("xib doesn't exist") }
         let productGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatCellTapped(_:)))
         cell.addGestureRecognizer(productGestureRecognizer)
         let message = messageDetails[indexPath.row]
         cell.textLbl.text = message
//         cell.textLabel?.text = message.senderID
//         cell.detailTextLabel?.text = message.message
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item based on the indexPath
        let selectedItem = messageDetails[indexPath.row]

        // Perform some action based on the selected item
        // For example, you can navigate to a new view controller
        // or display additional information about the selected item.
        
        // Example: Navigate to a new view controller
        let detailViewController = ChatDetailsViewController()
//        detailViewController.messages = selectedItem // Pass data to the detail view controller
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100)
        }
}
