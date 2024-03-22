//
//  PetRepository.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import Foundation
import RealmSwift

final class PetRepository {
    private let realm = try! Realm()
    
    func printLink() {
        print(self.realm.configuration.fileURL)
    }
    
    func fetch() -> Results<PetTable> {
        return realm.objects(PetTable.self)
    }
    
    func createItem(_ item: PetTable) {
        do{
            try realm.write {
                realm.add(item)
                print("Pet Register")
            }
        } catch {
            print(error)
        }
    }
    
    func editItem(id: ObjectId?, name: String, gender: Bool, birth: Date, meet: Date, weight: Double) {
        do {
            try realm.write {
                realm.create(PetTable.self,
                             value: ["id": id, "name": name, "gender": gender, "birth": birth, "meet": meet, "weight": weight],
                             update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: PetTable) {
        do{
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllItem() {
        do {
            try realm.write {
                let allPet = realm.objects(PetTable.self)
                realm.delete(allPet)
            }
        } catch {
            print(error)
        }
    }
    
}
