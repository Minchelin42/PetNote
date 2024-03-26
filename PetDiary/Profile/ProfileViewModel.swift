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
    var name = Observable("")
    var gender: Observable<Bool?> = Observable(nil)
    var firstMeet: Observable<Date?> = Observable(nil)
    var birth: Observable<Date?> = Observable(nil)
    var weight: Observable<Double?> = Observable(nil)
    //PetID (이미지의 이름으로 사용할 것)
    var petID = Observable("")
    
    var nowPet: Observable<PetTable?> = Observable(nil)
    
    var checkInputData = Observable(false)
    var checkDuplicate = Observable(false)
    var checkDate = Observable(false)
    
    var cameraButtonClicked: Observable<Void?> = Observable(nil)
    var genderButtonClicked: Observable<Void?> = Observable(nil)
    var dateButtonClicked: Observable<DateType?> = Observable(nil)
    var editButtonClicked: Observable<Void?> = Observable(nil)
    var registerButtonClicked: Observable<Void?> = Observable(nil)

    
    init() {
        nowPet.bind { pet in
            guard let pet = pet else { return }
            
            self.name.value = pet.name
            self.gender.value = pet.gender
            self.firstMeet.value = pet.meet
            self.birth.value = pet.birth
            self.weight.value = pet.weight
            self.petID.value = String(describing: pet.id)
        }
    }
    
    func findNowPet() {
        let target = PetRepository().fetch().where {
            $0.name.equals(UserDefaultManager.shared.nowPet)
        }
        self.nowPet.value = target[0]
    }
    
    func compareDate() {
        guard let birth = self.birth.value,
              let firstMeet = self.firstMeet.value else { return }
        
        switch birth.compare(firstMeet) {
        //동일한 날짜
        case .orderedSame: self.checkDate.value = false
        //생일보다 처음 만난 날이 더 빠름 -> x
        case .orderedDescending: self.checkDate.value = true
        //생일 이후에 만남
        case .orderedAscending: self.checkDate.value = false
        default: self.checkDate.value = false
        }
    }
    
    func checkInputDataStatus() {
        if let _ = gender.value, let _ = firstMeet.value, let _ = birth.value, let _ = weight.value {
            if name.value.isEmpty {
                self.checkInputData.value = false
            } else {
                self.checkInputData.value = true
            }
        } else {
            self.checkInputData.value = false
        }
    }
    
    func appendNewPet() {
        guard self.name.value != "",
              self.gender.value != nil,
              self.firstMeet.value != nil,
              self.birth.value != nil,
              self.weight.value != nil
        else { 
            print("입력된 정보가 부족합니다")
            return }
        
        let item = PetTable(name: self.name.value, gender: self.gender.value!, birth: self.birth.value!, meet: self.firstMeet.value!, weight: self.weight.value!)
        
        if !self.checkDate.value {
            repository.createItem(item)
            
            let registerPet = repository.fetch()
            
            if let id = registerPet.last?.id {
                self.petID.value = String(describing: id)
            }
        }
        
    }
    
    func duplicateTest() {
        
        let petName = self.name.value
        
        let pet = repository.fetch().where {
            $0.name.equals(petName)
        }

        if pet.isEmpty {
            self.checkDuplicate.value = false
        } else {
            //중복
            self.checkDuplicate.value = true
        }

    }
    
}
