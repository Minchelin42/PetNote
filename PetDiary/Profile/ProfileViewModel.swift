//
//  ProfileViewModel.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/10.
//

import Foundation

class ProfileViewModel {
    
    let repository = PetRepository()
    // 이름, 성별, 처음 만난 날, 태어난 날, 몸무게
    var name: Observable<String?> = Observable(nil)
    var gender: Observable<Bool?> = Observable(nil)
    var firstMeet: Observable<Date?> = Observable(nil)
    var birth: Observable<Date?> = Observable(nil)
    var weight: Observable<Double?> = Observable(nil)
    
    var checkInputData = Observable(false)
    var registerButtonClicked: Observable<Void?> = Observable(nil)
    
    init() {
        registerButtonClicked.bind { _ in
            self.appendNewPet()
        }
    }
    
    func checkInputDataStatus() {
        print("checkInputDataStatus")
        if let _ = name.value, let _ = gender.value, let _ = firstMeet.value, let _ = birth.value, let _ = weight.value {
            self.checkInputData.value = true
            print("지금 상태 체크 \(self.checkInputData.value)")
        } else {
            self.checkInputData.value = false
            print("지금 상태 체크 \(self.checkInputData.value)")
        }
    }
    
    private func appendNewPet() {
        guard self.name.value != nil,
              self.gender.value != nil,
              self.firstMeet.value != nil,
              self.birth.value != nil,
              self.weight.value != nil
        else { 
            print("입력된 정보가 부족합니다")
            return }
        
        let item = PetTable(name: self.name.value!, gender: self.gender.value!, birth: self.birth.value!, meet: self.firstMeet.value!, weight: self.weight.value!)
        
        repository.createItem(item)
        
    }
    
}
