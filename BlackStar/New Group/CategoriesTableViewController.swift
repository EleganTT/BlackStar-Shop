//
//  CategoriesTableViewController.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 08.04.2021.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var categories: [Category] = []
    var subcategories: [Subcategory] = []
    static var subcategoryId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        DataLoader().loadCategories { categories in
            self.categories = categories
            self.tableView.reloadData()
        }
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if subcategories.isEmpty {
            return categories.count
        } else {
            return subcategories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        
        if subcategories.isEmpty {
            cell.initCell(name: categories[indexPath.row].name, image: categories[indexPath.row].imageURL)
        } else {
            cell.initCell(name: subcategories[indexPath.row].name, image: subcategories[indexPath.row].imageURL)
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if subcategories.isEmpty {
            
            let selectedCategory = categories[indexPath.row]
            
            DataLoader().loadSubcategories(completion: { subcategories in
                self.subcategories = subcategories
            }, category: selectedCategory)
            
            if subcategories.isEmpty {
                performSegue(withIdentifier: "goToItemsCollection", sender: nil)
            }
            
            if !subcategories.isEmpty {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "chevron.backward"), style: .done, target: self, action: #selector(addTapped))
                navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            }
            
            self.tableView.reloadData()
        } else {
            performSegue(withIdentifier: "goToItemsCollection", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !subcategories.isEmpty {
            if segue.identifier == "goToItemsCollection" {
                let selectedSubcategory = subcategories[tableView.indexPathForSelectedRow!.row]
                CategoriesTableViewController.subcategoryId = subcategories[tableView.indexPathForSelectedRow!.row].id
                print(CategoriesTableViewController.subcategoryId)
                (segue.destination as! ItemsCollectionViewController).subcategory = selectedSubcategory
            }
        } else {
            if segue.identifier == "goToItemsCollection" {
                let selectedCategory = categories[tableView.indexPathForSelectedRow!.row]
                CategoriesTableViewController.subcategoryId = categories[tableView.indexPathForSelectedRow!.row].id
                print(CategoriesTableViewController.subcategoryId)
                (segue.destination as! ItemsCollectionViewController).category = selectedCategory
            }
        }

    }
    
    @objc func addTapped() {
        subcategories.removeAll()
        navigationItem.leftBarButtonItem = nil
        self.tableView.reloadData()
    }
    
    @objc func buttonAction(sender: UIButton) {
        performSegue(withIdentifier: "goToBasket", sender: nil)
    }
}

   
    

