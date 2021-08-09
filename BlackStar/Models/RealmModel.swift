//
//  RealmModel.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 27.05.2021.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var color = ""
    @objc dynamic var size = ""
    @objc dynamic var image = ""
    @objc dynamic var article = ""
    @objc dynamic var amount = Int()
}

class Persistence {
    static let shared = Persistence()
    private let realm = try! Realm()
    
    func saveData(item: Item, size: String, color: String, amount: Int) {
        let realmItem = RealmItem()
        realmItem.name = item.name
        realmItem.color = color
        realmItem.image = item.mainImage
        realmItem.price = item.price
        realmItem.size = size
        realmItem.article = item.article
        realmItem.amount = amount
        
        try! realm.write{
            realm.add(realmItem)
        }
    }
    
    func updateData(amount: Int, item: Item, size: String) {
        let realmItem = realm.objects(RealmItem.self)
        
        for i in realmItem {
            if item.article == i.article && item.colorName == i.color && size == i.size {
                try! realm.write {
                    i.amount = amount
                }
            }
        }
    }
    
    func totalAmount() -> Int {
        var total = Int()
        for i in realm.objects(RealmItem.self) {
            total += i.amount
        }
        return total
    }
    
    func loadData() -> Results<RealmItem> {
        let allItems = realm.objects(RealmItem.self)
        return allItems
    }
    
    func deleteData(item: RealmItem) {
        try! realm.write {
            realm.delete(item)
        }
    }
    
}
