//
//  CompleteInfoViewModel.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation
import RxSwift
import RxCocoa



class CompleteInfoViewModel {
    
    var allergyList = BehaviorRelay<[AllergyVO]>(value: [])
    var dietList = BehaviorRelay<[DietVO]>(value: [])
    var healthConcernList = BehaviorRelay<[HealthConcernVO]>(value: [])
    var selectedConcernList = BehaviorRelay<[HealthConcernVO]>(value: [])
    var selectedDietList = BehaviorRelay<[DietVO]>(value: [])
    var selectedAllergyList = BehaviorRelay<[AllergyVO]>(value: [])
    var dailyExposure = BehaviorRelay<String?>(value: nil)
    var isSmoke = BehaviorRelay<String?>(value: nil)
    var alcohol = BehaviorRelay<String?>(value: nil)
    
    private var infoModel: InfoModel!
    private let disposeBag = DisposeBag()
    
    var multipleChoiceList = [
                MultipleChoiceVO(question: "Is your daily exposure to sun is limited? *", options: ["Yes", "No"]),
                MultipleChoiceVO(question: "Do you current smoke (tobacco or marijuana)? *", options: ["Yes", "No"]),
                MultipleChoiceVO(question: "On average how many alcoholic beverages do you have in a week? *", options: ["0-1", "2-5", "5+"])
    ]
    
    init(infoModel: InfoModel) {
        self.infoModel = infoModel
    }
    
    func fetchAllData() {
        fetchHealthConcern()
        fetchDietList()
        fetchAllergyList()
    }
    
    private func fetchHealthConcern() {
        infoModel.fetchHealthConcernData(fileName: "health_concern").subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.healthConcernList.accept(response.data ?? [])
        }).disposed(by: disposeBag)
    }
    
    private func fetchAllergyList() {
        infoModel.fetchAllergyData(fileName: "allergies").subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.allergyList.accept(response.data ?? [])
        }).disposed(by: disposeBag)
    }
    
    private func fetchDietList() {
        infoModel.fetchDietData(fileName: "diets").subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            var tempArr = response.data ?? []
            tempArr.append(DietVO(id: -1, name: "None", toolTip: ""))
            tempArr.swapAt(0, tempArr.count - 1)
            self.dietList.accept(tempArr)
        }).disposed(by: disposeBag)
    }
    
    func getHealthConcernCount() -> Int {
        return healthConcernList.value.count
    }
    
    func getHealthConcern(by index: Int) -> HealthConcernVO {
        return healthConcernList.value[index]
    }
    
    func getDietCount() -> Int {
        return dietList.value.count
    }
    
    func getDiet(by index: Int) -> DietVO {
        return dietList.value[index]
    }
    
    func getAllergyStrList() -> [String] {
        let tempArr = allergyList.value
        return tempArr.map { $0.name ?? "" }
    }
    
    func getSelectedAllergyCount() -> Int {
        return selectedAllergyList.value.count
    }
    
    func getSelectedAllergy(by index: Int) -> AllergyVO {
        return selectedAllergyList.value[index]
    }
    
    func getMultipleChoiceCount() -> Int {
        return multipleChoiceList.count
    }
    
    func getMultipleChoice(by index: Int) -> MultipleChoiceVO {
        return multipleChoiceList[index]
    }
    
    func selectMCAns(for index: Int, with answer: String) {
        if index == 0 {
            dailyExposure.accept(answer)
        } else if index == 1 {
            isSmoke.accept(answer)
        } else {
            alcohol.accept(answer)
        }
    }
    
    func selectAllergy(by name: String) {
        if let index: Int = allergyList.value.firstIndex(where: { $0.name == name }) {
            let item = allergyList.value[index]
            var tempArr = selectedAllergyList.value
            if !tempArr.contains(where: {$0.id == item.id}) {
                tempArr.append(item)
                selectedAllergyList.accept(tempArr)
            }
        }
    }
    
    func selectDiet(by index: Int) {
        let item = dietList.value[index]
        var tempArr = selectedDietList.value
        tempArr.append(item)
        selectedDietList.accept(tempArr)
    }
    
    func deselectDiet(by index: Int) {
        let item = dietList.value[index]
        var tempArr = selectedDietList.value
        if let index: Int = tempArr.firstIndex(where: { $0.id == item.id }) {
            tempArr.remove(at: index)
            selectedDietList.accept(tempArr)
        }
    }
    
    func selectHealthConcern(by index: Int) {
        let item = healthConcernList.value[index]
        var tempArr = selectedConcernList.value
        tempArr.append(item)
        selectedConcernList.accept(tempArr)
    }
    
    func deselectHealthConcern(by index: Int) {
        let item = healthConcernList.value[index]
        var tempArr = selectedConcernList.value
        if let index: Int = tempArr.firstIndex(where: { $0.id == item.id }) {
            tempArr.remove(at: index)
            selectedConcernList.accept(tempArr)
        }
    }
    
    func swapRows(sourceIndex: Int, destIndex: Int) {
        var tempArr = selectedConcernList.value
        tempArr.swapAt(sourceIndex, destIndex)
        selectedConcernList.accept(tempArr)
    }
    
    func getSelectedHealthCount() -> Int {
        return selectedConcernList.value.count
    }
    
    func getSelectedHealth(by index: Int) -> HealthConcernVO {
        return selectedConcernList.value[index]
    }
    
    func submitData() {
        let params: [String: Any] = [
            "health_concerns": selectedConcernList.value.map { $0.toParams() },
            "diets": getFinalizedDietList().map { $0.toParams() },
            "is_daily_exposure": (dailyExposure.value ?? "") == "Yes",
            "is_smoke": (isSmoke.value ?? "") == "Yes",
            "alcohol": alcohol.value ?? "",
            "allergies": selectedAllergyList.value.map { $0.toParams() }
        ]
        print(params)
    }
    
    func getFinalizedDietList() -> [DietVO] {
        var tempArr = selectedDietList.value
        if tempArr.count == 1 && tempArr.first?.name == "None" {
            return []
        } else {
            return tempArr
        }
    }
}

