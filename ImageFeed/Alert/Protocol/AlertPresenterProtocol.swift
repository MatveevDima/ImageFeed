//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 17.07.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    
    func sendAlert(alertModel: AlertModel?, on viewController: UIViewController)
    
    func sendAlertNetworkError(on viewController: UIViewController)
    
    func sendAlertDidClickedExitButton(on viewController: UIViewController)
}
