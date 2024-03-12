//
//  PlanRepository.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/13.
//

import Foundation
import RealmSwift

final class PlanRepository {
    private let realm = try! Realm()
    
    func printLink() {
        print(self.realm.configuration.fileURL)
    }
    
    func fetch() -> Results<PlanTable> {
        return realm.objects(PlanTable.self)
    }
    
    func createItem(_ item: PlanTable) {
        do{
            try realm.write {
                realm.add(item)
                print("Plan Register")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: PlanTable) {
        do{
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}


