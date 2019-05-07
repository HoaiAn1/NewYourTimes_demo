//
//  BaseViewProtocol.swift
//  NewYourTimes_Demo
//
//  Created by An Le  on 5/7/19.
//  Copyright © 2019 An Le. All rights reserved.
//

import Foundation



/**
 Base Protocol for all Views/View Controllers
 */
protocol BaseViewProtocol {
    
    associatedtype Presenter: BasePresenterProtocol
    
    var presenter: Presenter { get set }
}