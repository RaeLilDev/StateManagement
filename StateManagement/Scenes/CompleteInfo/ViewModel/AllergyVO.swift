//
//  AllergyVO.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation

struct AllergyVO: Codable {
    let id: Int?
    let name: String?
    
    func toParams() -> [String: Any] {
        [
            "id": self.id ?? 0,
            "name": self.name ?? ""
        ]
    }
}
