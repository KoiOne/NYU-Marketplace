//
//  ConversationViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/24/22.
//

import UIKit
import FirebaseAuth
import Parse

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    private var conversations = [Conversation]()
    
    private var currentEmail = PFUser.current()?.email 
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(noConversationLabel)
        fetchConversation()
        startListeningForConversation()

        // Do any additional setup after loading the view.
    }
    private func createNewConversation() {
        
    }
    
    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private func fetchConversation() {
        
    }
    
    private func startListeningForConversation() {
        print("starting conversation")
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail!)
        DatabaseManager.shared.getAllConversation(for: safeEmail, completion: { [weak self]result in
            switch result{
            case.success(let conversation):
                print("success fetch")
                guard !conversation.isEmpty else {
                    return
                }
                self?.conversations = conversation
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                print("fail to get conversation: \(error)")
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.nameLabel.text = model.name
        cell.messageLabel.text = model.latestMessage.text
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = conversations[indexPath.row]
//        self.performSegue(withIdentifier: "converToChatSegue", sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "converToChatSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let model = conversations[indexPath!.row]
            let chatView = segue.destination as! ChatViewController
            chatView.otherUserEmail = model.otherUserEmail
            chatView.otherUserName = model.name
            chatView.conversationId = model.id
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
