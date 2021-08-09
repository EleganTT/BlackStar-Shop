//
//  ItemsCollectionViewCell.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 24.04.2021.
//

import UIKit


protocol GoToItemCellDelegate {
    func goToItem(index: Int)
}

class ItemsCollectionViewCell: UICollectionViewCell {
    
    var cellIndex = -1
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBAction func buyButtonAction(_ sender: Any) {
        delegate?.goToItem(index: cellIndex)
    }
    
    var delegate: GoToItemCellDelegate?
    
    override func awakeFromNib() {
    super.awakeFromNib()
        buyButton.layer.cornerRadius = self.contentView.frame.size.height / 50
    }
}
