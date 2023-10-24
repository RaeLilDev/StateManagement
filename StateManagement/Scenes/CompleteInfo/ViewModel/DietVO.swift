//
//  DietVO.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation

struct DietVO: Codable {
    let id: Int?
    let name: String?
    let toolTip: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case toolTip = "tool_tip"
    }
    
    func toParams() -> [String: Any] {
        [
            "id": self.id ?? 0,
            "name": self.name ?? "",
            "tool_tip": self.toolTip ?? ""
        ]
    }
}
