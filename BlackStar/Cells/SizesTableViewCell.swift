//
//  SizesTableViewCell.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 21.05.2021.
//

import UIKit

protocol SizesCellDelegate {
    func getSizeLabelHidden(image: UIImageView)
    func getSizeLabelVisible(image: UIImageView)
}

class SizesTableViewCell: UITableViewCell {
    
    var delegate: SizesCellDelegate?

    @IBOutlet weak var sizeCheckmark: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sizeCheckmark.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            delegate?.getSizeLabelVisible(image: sizeCheckmark)
        } else if selected == false {
            delegate?.getSizeLabelHidden(image: sizeCheckmark)
        }
    }
    
    
}


