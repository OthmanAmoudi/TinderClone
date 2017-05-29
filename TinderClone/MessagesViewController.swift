//
//  MessagesViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 29/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
class MessagesViewController: JSQMessagesViewController {

    
    var messages = [JSQMessage]()
    var messageRef = Database.database().reference().child("messages")
    var avatarDict = [String: JSQMessagesAvatarImage]()


    @IBAction func unmatchBtn(_ sender: Any) {
    }
    
    @IBAction func backBtn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        self.navigationItem.title="New Message"
        if let currentUser = Auth.auth().currentUser{
            
            self.senderId = currentUser.uid
            self.senderDisplayName = "\(currentUser.displayName!)"
            
            
        }
        
//        self.senderId = "1234"
//        self.senderDisplayName = "TEST"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    func observeUsers(id: String){
        Database.database().reference().child("users").child(id).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                print("@@@@@\(dict)")
              //  let avatarUrl = dict["profileUrl"] as! String
                
                
            }
        })
    }
    
    func observeMessages(){
        Database.database().reference().child("messages").observe(.childAdded, with: {snapshot in
            if let dict = snapshot.value as? [String: AnyObject]{
                // let mediaType = dict["MediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                let text = dict["text"] as? String
                
                self.observeUsers(id: senderId)
                self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                self.collectionView.reloadData()
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if message.senderId == self.senderId{
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .blue)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .magenta)
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.row]
        return avatarDict[message.senderId]
        
        //return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print("didPressSendButton")
        print("XXXXXXXXXXXXXX\(text)")
        print(senderId)
        print(senderDisplayName)
        
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
                collectionView.reloadData()
            print(messages)
        
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "Media Type": "text message"]
        
        let newMessage = messageRef.childByAutoId()
        newMessage.setValue(messageData)
        self.finishSendingMessage()
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("did Tapped buble at indexpath: \(indexPath.item)")
        let message = messages[indexPath.item]
      
        }
    }





