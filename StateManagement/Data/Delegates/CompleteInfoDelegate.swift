//
//  CompleteInfoDelegate.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation

protocol CompleteInfoDelegate: AnyObject {
    
    func didChangeStep(isForward: Bool)
    
    func didTapFinish()
    
    func popToRoot()
}
