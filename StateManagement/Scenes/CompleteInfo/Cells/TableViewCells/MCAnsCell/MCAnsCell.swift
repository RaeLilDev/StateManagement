//
//  MCAnsCell.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

class MCAnsCell: UITableViewCell {
    
    @IBOutlet weak var ivOverlay: UIImageView!
    @IBOutlet weak var lblAns: UILabel!
    
    var data: String? {
        didSet {
            if let data = data {
                lblAns.text = data
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        ivOverlay.image = selected ? UIImage(systemName: "largecircle.fill.circle") : UIImage(systemName: "circle")
    }
    
}
