//
//  HomeViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/14/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func toProfile(_ sender: Any) {
    }
    
    
    @IBAction func toAllPosts(_ sender: Any) {
        self.performSegue(withIdentifier: "allPostsSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
