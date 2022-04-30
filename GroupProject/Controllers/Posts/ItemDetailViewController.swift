//
//  ItemDetailViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/16/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageKit

class ItemDetailViewController: UIViewController{
        
    public var completion: ((_ String: String, String, String) -> (Void))?
    
    var post: PFObject?
    
    @IBOutlet weak var posterView: UIImageView?
    
    @IBOutlet weak var priceLabel: UILabel?
    
    @IBOutlet weak var nameLabel: UILabel?
    
    @IBOutlet weak var locationLabel: UILabel?
    
    @IBOutlet weak var descriptionLabel: UILabel?
    
    private var emailAddress: String? = ""
    
    private var otherUser: String? = ""
    
    @IBAction func startChat(_ sender: Any) {
        self.performSegue(withIdentifier: "toChatSegue", sender: nil)
//        var vc = ItemDetailViewController()
//        createNewChat(emailA: emailAddress!, user: otherUser!)
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: false)
    }
    
//    func createNewChat(emailA: String, user: String){
//        let vc = ChatViewController(with: emailA)
//        vc.isNewChat = true
//        vc.title = otherUser
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toChatSegue"){
            let chatView = segue.destination as! ChatViewController
            //chatView.isNewChat = true
            chatView.otherUserEmail = emailAddress!
            chatView.otherUserName = otherUser!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if post != nil {
            priceLabel?.text = post?["price"] as? String
            nameLabel?.text = post?["name"] as! String
            locationLabel?.text = post?["location"] as! String
            descriptionLabel?.text = post?["description"] as! String
            emailAddress = post?["ownerEmail"] as! String
            let owner = post?["owner"] as! PFUser
            otherUser = owner.username!
            
            
            let imageFile = post?["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            posterView?.af_setImage(withURL: url)
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

