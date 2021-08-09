//
//  BasketViewController.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 27.05.2021.
//

import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = Persistence().loadData()

    @IBOutlet weak var getOrderButton: UIButton!
    
    @IBAction func getOrderButtonAction(_ sender: Any) {
        
    }
    
    @IBOutlet weak var totalLabel: UILabel!
    
    func getTotalAmount() {
        var totalPrice = 0
        for item in items {
            let doublePrice = Double(item.price)
            let intPrice = Int(doublePrice ?? 0)
            totalPrice += intPrice * item.amount
        }
        totalLabel.text = "\(totalPrice) руб."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getTotalAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: Change top bar icon
        if items.isEmpty {
            getOrderButton.setTitle("На главную", for: .normal)
            getOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold) }
        else {
            getOrderButton.setTitle("Оформить заказ", for: .normal)
            getOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        }
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(systemName: "multiply")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(systemName: "multiply")
        self.navigationController?.navigationBar.tintColor = .gray
        
        getOrderButton.layer.cornerRadius = 20
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        cell.delegate = self
        
        cell.deleteButton.tag = indexPath.row
        
        cell.initBasketCell(item: items[indexPath.row])
        
        cell.basketViewController = self
        return cell
    }
}

extension BasketViewController: BasketTableViewCellDelegate {
    func deleteItem(index: Int) {
            Persistence().deleteData(item: items[index])
            tableView.reloadData()
    }
}
