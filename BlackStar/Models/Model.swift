//
//  Model.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 08.04.2021.
//

import UIKit

class Category{
    let name: String
    let imageURL: String
    var subcategories: NSArray
    var id: String

    init?(data: NSDictionary, key: String){
        guard let name = data["name"] as? String,
              let imageURL = data["image"] as? String else { return nil }
        self.name = name
        self.id = key
        self.imageURL = imageURL
        self.subcategories = data["subcategories"] as! NSArray
    }
}

class Subcategory{
    let name: String
    let imageURL: String
    var id: String

    init?(data: NSDictionary){
        guard let name = data["name"] as? String,
              let id = data["id"] as? String,
              let imageURL = data["iconImage"] as? String else { return nil }
        self.name = name
        self.id = id
        self.imageURL = imageURL
    }
}

class Item{
    let name: String
    let description: String
    let price: String
    let article: String
    let colorName: String
    let mainImage: String
    let productImages: NSArray
    let offers: NSArray
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
              let description = data["description"] as? String,
              let mainImage = data["mainImage"] as? String,
              let article = data["article"] as? String,
              let colorName = data["colorName"] as? String,
              let productImages = data["productImages"] as? NSArray,
              let offers = data["offers"] as? NSArray,
              let price = data["price"] as? String else { return nil }
        self.name = name
        self.description = description
        self.price = price
        self.article = article
        self.colorName = colorName
        self.mainImage = mainImage
        self.productImages = productImages
        self.offers = offers
    }
}

class ProductImages{
    let imageURL: String
    
    init?(data: NSDictionary) {
        guard let imageURL = data["imageURL"] as? String else { return nil }
        self.imageURL = imageURL
    }
}

class Offers{
    let size: String
    let quantity: String
    let productOfferID: String
    
    init?(data: NSDictionary) {
        guard let size = data["size"] as? String,
              let quantity = data["quantity"] as? String,
              let productOfferID = data["productOfferID"] as? String else { return nil }
        
        self.size = size
        self.quantity = quantity
        self.productOfferID = productOfferID
    }
}
