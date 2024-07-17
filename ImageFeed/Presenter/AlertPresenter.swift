//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 17.07.2024.
//

import UIKit

class AlertPresenter : AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func sendAlert(alertModel: AlertModel?, on viewController: UIViewController) {
        
        guard let alertModel = alertModel else { return }
        
        let alert = UIAlertController(
                title: alertModel.title,
                message: alertModel.message,
                preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "Alert"
            
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in

            alertModel.completion()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func sendAlertNetworkError(on viewController: UIViewController) {
        sendAlert(alertModel: AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "ОК"
        ) { [weak self] in
            
        }, on: viewController)
    }
}
