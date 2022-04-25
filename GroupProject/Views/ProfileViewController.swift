//
//  ProfileViewController.swift
//  GroupProject
//
//  Created by Chen Hanrui on 2022/4/23.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var portraitView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var logout: UIBarButtonItem!
    var user = PFUser.current()
    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //portraitView.image = UIImage.init(named: "image_placeholder")

        let imageFile = user?.object(forKey: "profileImage") as? PFFileObject
        let urlString = imageFile?.url! ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fplaceholder-image&psig=AOvVaw3pCogNxkeyJT4TEgu-QMkM&ust=1650828967471000&source=images&cd=vfe&ved=0CAkQjRxqFwoTCPi1nKX3qvcCFQAAAAAdAAAAABAU"
        let url = URL(string: urlString)!
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data!)
        let size = CGSize(width: 150, height: 150)
        let scaledImage = image?.af_imageScaled(to: size)
        
        portraitView.image = scaledImage
        //portraitView.af_setImage(withURL: url)
        
        portraitView.sizeToFit()
        portraitView.layer.cornerRadius = portraitView.frame.size.width/2
        portraitView.clipsToBounds = true
        
        name.text = user?.object(forKey: "username") as? String
        email.text = user?.object(forKey: "email") as? String
        
        var lineView = UIView(frame: CGRect(x:0, y: 345, width: 500, height: 2.0))
        lineView.layer.borderWidth = 2.0
        lineView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name:"Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Items")
        query.includeKeys(["name","price","owner","location","description"])
        query.limit = 20
        let userid = self.user?.objectId as? String
        query.findObjectsInBackground{
            (posts, error) in
            
            if error == nil {
                if let returnedobjects = posts{
                    for post in returnedobjects{
                        let postOwner = post["owner"] as! PFUser
                        let postOwnerId = postOwner.objectId as? String
                        if userid == postOwnerId{
                            self.posts.append(post)
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
    @objc func loadMorePosts(){
        let query = PFQuery(className: "Items")
        query.includeKeys(["name","price","owner","location","description"])
        query.limit = 20
        let userid = self.user?.objectId as? String
        query.findObjectsInBackground{
            (posts, error) in
            
            if error == nil {
                if let returnedobjects = posts{
                    for post in returnedobjects{
                        let postOwner = post["owner"] as! String
                        if userid == postOwner{
                            self.posts.append(post)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let post = posts[section]
//        let comments = (post["comments"] as? [PFObject]) ?? []
//
//        return comments.count + 2
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        //let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousPostCell") as! PreviousPostCell
            
            let price = post["price"] as! String
            cell.priceLabel.text = "Price:" + price
            
            cell.descriptionLabel.text = post["description"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.itemView.af.setImage(withURL: url)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
    }
    
    
    
    @objc func onRefresh() {
        run(after: 2) {
               self.refreshControl.endRefreshing()
            }
    }
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let post = posts[section]
        return posts.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = posts[indexPath.section]
//        let comment = (post["comments"] as? [PFObject]) ?? []
//
//        if indexPath.row == comment.count + 1 {
//            showsCommentBar = true
//            becomeFirstResponder()
//            commentBar.inputTextView.becomeFirstResponder()
//
//            selectedPost = post
//        }
//
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
