//
//  UserTableViewCell.swift
//  RandomUserCodeChallenge
//
//  Created by Ryan Anderson on 3/5/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(user: User){
        usernameLabel.text = user.name
    }
}
