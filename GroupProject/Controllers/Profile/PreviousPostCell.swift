//
//  PreviousPostCell.swift
//  GroupProject
//
//  Created by Chen Hanrui on 2022/4/25.
//

import UIKit

class PreviousPostCell: UITableViewCell {
    
    @IBOutlet weak var itemView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
