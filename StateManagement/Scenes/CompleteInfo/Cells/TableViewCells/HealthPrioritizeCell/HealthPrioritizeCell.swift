//
//  HealthPrioritizeCell.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

class HealthPrioritizeCell: UITableViewCell {

    @IBOutlet weak var nameContainer: UIStackView!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    var data: HealthConcernVO? {
        didSet {
            if let data = data {
                lblName.text = data.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameContainer.layer.cornerRadius = 20.0
        contentContainer.layer.borderColor = UIColor(named: "colorHighlight")?.cgColor
        contentContainer.layer.borderWidth = 0.0
        contentContainer.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
