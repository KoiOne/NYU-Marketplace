//
//  ConversationViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/24/22.
//

import UIKit

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(noConversationLabel)
        fetchConversation()

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
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
