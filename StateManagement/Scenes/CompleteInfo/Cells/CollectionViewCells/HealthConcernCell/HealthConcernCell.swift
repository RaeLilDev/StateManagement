//
//  HealthConcernCell.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

class HealthConcernCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var lblName: UILabel!
    
    var data: HealthConcernVO? {
        didSet {
            if let data = data {
                lblName.text = data.name
            }
        }
    }
    
    var allergy: AllergyVO? {
        didSet {
            if let allergy = allergy {
                lblName.text = allergy.name
                lblName.textColor = .white
                containerView.backgroundColor = UIColor(named: "colorHighlight")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 20.0
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(named: "colorHighlight")?.cgColor
    }

    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? UIColor(named: "colorHighlight") : .clear
            lblName.textColor = isSelected ? .white : UIColor(named: "colorHighlight")
        }
    }
}
