//
//  chatViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/15/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Parse

class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    } ()
    
    public var conversationId = ""
    
    public var otherUserEmail = ""
    
    public var otherUserName = ""
    
    public var currentEmail = PFUser.current()?.email
    
    public var isNewChat = false
    
    
    private var messages = [Message]()
    
    private var selfSender: Sender?  {
        guard let email = currentEmail else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return Sender(senderId: safeEmail as! String, displayName: "me")
        
        
    }
    
    
    
//    init(with email:String){
//        //self.otherUserEmail = email
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = otherUserName
        print(otherUserEmail)
        self.title = otherUserName
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

        
    }
    
    private func listenForMessages(id: String, shouldScroll: Bool){
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self]result in
            switch result {
            case.success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScroll {
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                    
                }
            case.failure(let error):
                print("fail to get message: \(error)")
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        messageInputBar.inputTextView.becomeFirstResponder()
        listenForMessages(id: self.conversationId,shouldScroll: true)
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageId = createMessageId() else{
            print("failed")
            return
        }
        
        print("Sending: \(text)")
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        //send message
        if isNewChat{
            // create new chat
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: otherUserName, firstMessage: message, completion: {[weak self] success in
                if success {
                    print("sent")
                    self?.isNewChat = false
                } else {
                    print("fail to sent")
                }
            })
        }
        else{
            // append to existing one
            print(self.conversationId)
            DatabaseManager.shared.sendMessageToConversation(to: self.conversationId, otherUserEmail: otherUserEmail,name: otherUserName, newMessage: message, completion: { success in
                if success{
                    print("message sent")
                }
                else{
                    print("fail to sent")

                }
            })
        }
    }
    
    private func createMessageId() -> String? {
        guard let currentEmail = currentEmail else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newId = "\(otherUserName)_\(safeCurrentEmail)_\(dateString)"
        print(newId)
        return newId
    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("sender is nil")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind{
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}
