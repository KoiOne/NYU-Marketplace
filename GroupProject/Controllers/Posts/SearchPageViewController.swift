//
//  searchPageViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/24/22.
//

import UIKit
import Parse
import AlamofireImage

class SearchPageViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noResultLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search for items..."
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noResultLabel.frame = CGRect(x: view.frame.width/4,
                                     y: (view.frame.height-200)/2,
                                     width: view.frame.width/2,
                                     height: 200)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.priceLabel.text = post["price"] as? String
        cell.nameLabel.text = (post["name"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.imageView?.af_setImage(withURL: url)
        return cell
    }
    
    // Search for items
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        
        self.searchItems(input: text)
        updateUI()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        posts.removeAll()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    
    func searchItems(input: String){
        let query = PFQuery(className: "Items")
        query.order(byDescending: "createdAt")
        query.includeKeys(["name","price","owner","location","description"])
        query.limit = 20
        query.whereKey("nameSearch", contains: input.lowercased())
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateUI() {
        if posts.isEmpty {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
        }
        else {
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new controller
        if sender != nil{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let item = posts[indexPath!.row]

            let deailViewController = segue.destination as! ItemDetailViewController
            deailViewController.post = item
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
