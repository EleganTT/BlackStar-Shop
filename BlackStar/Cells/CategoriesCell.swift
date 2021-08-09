//
//  CategoriesCell.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 14.04.2021.
//

import UIKit

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImageView.layer.cornerRadius = self.frame.size.height / 2.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(name: String, image: String) {
        categoryLabel.text = name
        DataLoader().loadImages(url: image, view: categoryImageView)
    }
    
}
