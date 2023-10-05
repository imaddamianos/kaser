//
//  ChatCalls.swift
//  kaser
//
//  Created by iMad on 02/10/2023.
//

import Firebase

// Function to create a new chat
func createChat(userType: String, user1ID: String, user2ID: String) -> String {
    // Generate a unique chat ID
    let chatID = generateUniqueChatID(user1ID: user1ID, user2ID: user2ID)

    // Update the database with the chat information
    ref.child(userType).child(newID!).child("chats/\(chatID)/users").setValue([user1ID, user2ID])

    // Now, both users can send and receive messages in this chat room
    return chatID
}

// Function to generate a unique chat ID (you can use your own logic)
func generateUniqueChatID(user1ID: String, user2ID: String) -> String {
    // You can create a unique chat ID based on user IDs or use Firebase's childByAutoId().key as shown in the previous example
    let chatID = "\(user1ID)_\(user2ID)"
    return chatID
}

