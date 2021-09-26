//
//  RealmContaining.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 25.09.2021.
//

import UIKit
import RealmSwift


protocol RealmContaining {}

extension RealmContaining {
    
    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                print("Something wrong during connecting to realm")
            }
            
            return self.realm
        }
    }
    
    func saveToRealm(_ object: Object) throws {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            throw error
        }
        
    }
    
    func getFromRealm<T: Object>(_ object: T.Type = T.self) -> Results<T> {
        return realm.objects(T.self)
    }

}

