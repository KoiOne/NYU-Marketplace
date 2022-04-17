//
//  ItemDetailViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/16/22.
//

import UIKit
import Parse
import AlamofireImage

class ItemDetailViewController: UIViewController{
        
    
    var post: PFObject?
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        priceLabel.text = post?["price"] as! String
        nameLabel.text = post?["name"] as! String
        locationLabel.text = post?["location"] as! String
        descriptionLabel.text = post?["description"] as! String
        
        
        let imageFile = post?["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        posterView.af_setImage(withURL: url)
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

