//
//  UserCell.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    @IBOutlet var labelCollections: [UILabel]!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var imageWrapperView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
