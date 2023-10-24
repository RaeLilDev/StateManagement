//
//  ApiService.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation
import RxSwift

class ApiService {
    
    static let shared = ApiService()
    
    func decodeJSON<T: Codable>(fileName: String, objectType: T.Type) -> Observable<T> {
        return Observable.create { observer in
            guard let jsonURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                observer.onError(NSError(domain: "YourAppErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON file not found in the bundle."]))
                return Disposables.create()
            }
            
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(objectType, from: jsonData)

                observer.onNext(decodedObject)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}
