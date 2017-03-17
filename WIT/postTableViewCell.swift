//
//  postTableViewCell.swift
//  WIT
//
//  Created by Shay Kremer on 1/15/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
//view for prototype of table view cell
class postTableViewCell: UITableViewCell {

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var usr: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var postIMG: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //enabling choosing cell from the list
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
