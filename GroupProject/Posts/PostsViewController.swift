//
//  PostsViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/14/22.
//

import UIKit
import Parse
import AlamofireImage

class PostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set Layout of collectionView
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let width = view.frame.size.width / 2
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        refreshControl.addTarget(self, action: #selector(viewDidAppear), for: .valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
    }
    
    let refreshControl = UIRefreshControl()
    
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        // Implement the delay method
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    
    func refresh() {
        // refresh after 2 second delay
        run(after: 2) {
           self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let query = PFQuery(className: "Items")
        query.order(byDescending: "createdAt")
        query.includeKeys(["name","price","owner","location","description"])
        query.limit = 20
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.collectionView.reloadData()
                self.refresh()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new controller
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let item = posts[indexPath!.row]
        
        let deailViewController = segue.destination as! ItemDetailViewController
        deailViewController.post = item


    }
    
    
    
    func collectionView(_ tableView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCell", for: indexPath) as! PostsCell
        
        cell.priceLabel.text = post["price"] as? String
        cell.nameLabel.text = (post["name"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.posterView.af_setImage(withURL: url)
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
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
