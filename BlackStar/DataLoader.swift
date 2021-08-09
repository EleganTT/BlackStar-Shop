//
//  DataLoader.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 08.04.2021.
//

import Foundation
import UIKit
import Alamofire

class DataLoader {
    
    func loadCategories(completion: @escaping ([Category]) -> Void){
        AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories").responseJSON { response in
            if let objects = response.value,
               let jsonDict = objects as? NSDictionary{
                DispatchQueue.main.async {
                    var categories: [Category] = []
                    var keys = [String]()
                    
                    for (key, data) in jsonDict where data is NSDictionary{
                        if let category = Category(data: data as! NSDictionary, key: key as! String){
                            categories.append(category)
                        }
                        keys.append(key as! String)
                    }
                    completion(categories)
                }
            }
        }
    }
    
    func loadItems(completion: @escaping ([Item]) -> Void) {
        AF.request("https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=" + CategoriesTableViewController.subcategoryId).responseJSON { response in
            if let objects = response.value,
               let jsonDict = objects as? NSDictionary{
                DispatchQueue.main.async {
                    var items: [Item] = []
                    for (_, data) in jsonDict where data is NSDictionary{
                        if let item = Item(data: data as! NSDictionary) {
                            items.append(item)
                        }
                    }
                    completion(items)
                }
            }
        }
    }
    
    func loadImages(url: String, view: UIImageView){
        
        AF.request("https://blackstarshop.ru/" + url, method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                view.image = UIImage(data: responseData!)
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
    
    func loadSubcategories(completion: @escaping ([Subcategory]) -> Void, category: Category){
            var subcategories = [Subcategory]()
            for data in category.subcategories where data is NSDictionary{
                if let subcategory = Subcategory(data: data as! NSDictionary) {
                    subcategories.append(subcategory)
                }
            }
        completion(subcategories)
    }
    
    func loadProductImages(completion: @escaping ([ProductImages]) -> Void, item: Item){
            var productImages = [ProductImages]()
            for data in item.productImages where data is NSDictionary{
                    if let productImage = ProductImages(data: data as! NSDictionary) {
                        productImages.append(productImage)
                    }
                }
            completion(productImages)
    }
    
    func loadOffers(completion: @escaping ([Offers]) -> Void, item: Item){
        var offers = [Offers]()
        for data in item.offers where data is NSDictionary{
                if let offer = Offers(data: data as! NSDictionary) {
                    offers.append(offer)
                }
            }
        completion(offers)
    }
}
