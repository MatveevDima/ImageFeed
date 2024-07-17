//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 17.07.2024.
//

import Foundation

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> (Void)
}
