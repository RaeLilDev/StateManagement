//
//  BaseResponse.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T?
}
