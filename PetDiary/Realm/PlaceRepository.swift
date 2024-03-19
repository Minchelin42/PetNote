//
//  PlaceRepository.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/19.
//

import Foundation
import RealmSwift

final class PlaceRepository {
    private let realm = try! Realm()
    
    func printLink() {
        print(self.realm.configuration.fileURL)
    }
    
    func fetch() -> Results<PlaceTable> {
        return realm.objects(PlaceTable.self)
    }
    
    func inputItem(_ items: [PlaceTable]) {
        do {
            try realm.write {
                realm.add(items)
                print("Place Array Register")
            }
        } catch {
            print(error)
        }
    }
    
    func createItem(_ item: PlaceTable) {
        do {
            try realm.write {
                realm.add(item)
//                print("Place Register")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllItem() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}
