//
//  BasketTableViewCell.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 13.05.2021.
//

import UIKit

protocol BasketTableViewCellDelegate {
    func deleteItem(index: Int)
}


class BasketTableViewCell: UITableViewCell {

    var basketViewController = BasketViewController()
    
    var delegate: BasketTableViewCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButton(_ sender: UIView) {
        let alertController = UIAlertController(title: "Удалить товар из корзины?", message: "", preferredStyle: .alert)
        
        let alertActionYes = UIAlertAction(title: "Да", style: .default) { [self] (alert) in
            self.delegate?.deleteItem(index: sender.tag)
            basketViewController.getTotalAmount()
            basketViewController.setButtonTitle()
        }
        
        let alertActionNo = UIAlertAction(title: "Нет", style: .default) { (alert) in
        }
        
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        
        basketViewController.present(alertController, animated: true, completion: nil)
    }
    
    func initBasketCell(item: RealmItem) {
        let doublePrice = Double(item.price)
        let intPrice = Int(doublePrice ?? 0)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = " "
        
        nameLabel.text = item.name
        DataLoader().loadImages(url: item.image, view: itemImageView!)
        
        sizeLabel.text = "Размер: \(item.size)"
        colorLabel.text = "Цвет: \(item.color.lowercased())"
        nameLabel.text = item.name
        amountLabel.text = "\(item.amount) шт."
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:intPrice * item.amount)) {
            priceLabel.text = formattedNumber + " руб."
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
