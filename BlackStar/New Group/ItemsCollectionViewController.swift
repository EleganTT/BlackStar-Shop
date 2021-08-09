//
//  ItemsCollectionViewController.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 24.04.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class ItemsCollectionViewController: UICollectionViewController {

    var items: [Item] = []
    var subcategory: Subcategory?
    var subcategories: [Subcategory] = []
    var category: Category?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataLoader().loadItems { items in
            self.items = items
            self.collectionView.reloadData()
        }
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK: Add badge on navigation right bar button
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        rightBarButton.tintColor = .systemGray2
        rightBarButton.setBackgroundImage(UIImage(systemName: "cart.fill", compatibleWith: .none), for: .normal)
        rightBarButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)

        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.rightBarButtonItem?.addBadge(number: Persistence().totalAmount())
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
        let item = items[indexPath.row]
        cell.cellIndex = indexPath.row
    
        DataLoader().loadImages(url: item.mainImage, view: cell.itemImage)

        let doublePrice = Double(item.price)
        let intPrice = Int(doublePrice ?? 0)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = " "
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:intPrice)) {
            cell.itemPrice.text = formattedNumber + " ₽"
        }
        cell.frame.size.width = view.frame.size.width / 2
    
        cell.delegate = self
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem" {
            let selectedItem = items[sender as! Int]
            (segue.destination as! ItemViewController).item = selectedItem
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        performSegue(withIdentifier: "goToBasket", sender: nil)
    }
}


extension ItemsCollectionViewController: GoToItemCellDelegate {
    func goToItem(index: Int) {
        performSegue(withIdentifier: "goToItem", sender: index)
    }
}


