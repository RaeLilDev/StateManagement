//
//  InfoModel.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation
import RxSwift

protocol InfoModel {
    func fetchHealthConcernData(fileName: String) -> Observable<BaseResponse<[HealthConcernVO]>>
    
    func fetchAllergyData(fileName: String) -> Observable<BaseResponse<[AllergyVO]>>
    
    func fetchDietData(fileName: String) -> Observable<BaseResponse<[DietVO]>>
}

class InfoModelImpl: InfoModel {
    
    let service = ApiService.shared
    static let shared = InfoModelImpl()
    
    private init() {}
    
    func fetchHealthConcernData(fileName: String) -> Observable<BaseResponse<[HealthConcernVO]>> {
        service.decodeJSON(fileName: fileName, objectType: BaseResponse<[HealthConcernVO]>.self)
    }
    
    func fetchAllergyData(fileName: String) -> Observable<BaseResponse<[AllergyVO]>> {
        service.decodeJSON(fileName: fileName, objectType: BaseResponse<[AllergyVO]>.self)
    }
    
    func fetchDietData(fileName: String) -> Observable<BaseResponse<[DietVO]>> {
        service.decodeJSON(fileName: fileName, objectType: BaseResponse<[DietVO]>.self)
    }
}
