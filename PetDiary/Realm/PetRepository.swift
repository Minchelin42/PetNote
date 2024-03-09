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
    
    func deleteItem(_ item: PetTable) {
        do{
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
