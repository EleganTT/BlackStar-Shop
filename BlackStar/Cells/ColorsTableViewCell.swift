//
//  ColorsTableViewCell.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 19.05.2021.
//

import UIKit

protocol ColorsCellDelegate {
    func getColorLabelHidden(image: UIImageView)
    func getColorLabelVisible(image: UIImageView)
}

class ColorsTableViewCell: UITableViewCell {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorCheckMark: UIImageView!
    
    var delegate: ColorsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorCheckMark.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            delegate?.getColorLabelVisible(image: colorCheckMark)
        } else if selected == false {
            delegate?.getColorLabelHidden(image: colorCheckMark)
        }
    }
    

}
