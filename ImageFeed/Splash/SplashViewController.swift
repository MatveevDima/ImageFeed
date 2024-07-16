//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController : UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

           if let token = oAuth2TokenStorage.token {
               switchToTabBarController()
           } else {
               performSegue(withIdentifier: SplashViewController.authenticationScreenSegueIdentifier, sender: nil)
           }
    }
}

extension SplashViewController {
    
    static let authenticationScreenSegueIdentifier = "authenticationScreenSegueIdentifier"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SplashViewController.authenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(SplashViewController.authenticationScreenSegueIdentifier)")
                return
            }
            viewController.authViewControllerDelegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController, code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
        
            self.fetchOAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
