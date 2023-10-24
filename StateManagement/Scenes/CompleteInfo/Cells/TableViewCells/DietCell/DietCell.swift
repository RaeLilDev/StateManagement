//
//  DietCell.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import EasyTipView

class DietCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivInfo: UIImageView!
    @IBOutlet weak var ivCheck: UIImageView!
    
    var data: DietVO? {
        didSet {
            if let data = data {
                lblName.text = data.name
                ivInfo.isHidden = (data.toolTip?.isEmpty ?? false)
            }
        }
    }
    
    var preferences = EasyTipView.Preferences()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.left
        
        let tapInfo = UITapGestureRecognizer(target: self, action: #selector(onTapInfo))
        ivInfo.isUserInteractionEnabled = true
        ivInfo.addGestureRecognizer(tapInfo)
    }
    
    @objc private func onTapInfo() {
        let tipView = EasyTipView(text: data?.toolTip ?? "", preferences: preferences)
        tipView.show(forView: ivInfo, withinSuperview: self.contentView)
        ivInfo.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            tipView.dismiss()
            self.ivInfo.isUserInteractionEnabled = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        ivCheck.image = selected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square.dashed")
    }
    
}
