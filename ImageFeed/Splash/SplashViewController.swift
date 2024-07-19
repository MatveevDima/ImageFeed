//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController : UIViewController {
    
    private var logo: UIImageView!
    
    private var alertPresenter: AlertPresenterProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token)
        } else {
            let vc = createAndSetupAuthViewController()
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Setup View
    private func setupView() {
        setupSuperView()
        setupLogoImageView()
    }
    
    private func setupSuperView() {
        view.backgroundColor = UIColor(named: "YP Black") ?? UIColor.black
    }
    
    private func setupLogoImageView() {
        logo = UIImageView(image: UIImage(named: "Vector")!)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.tintColor = .none
        
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalToConstant: 78),
            logo.widthAnchor.constraint(equalToConstant: 75),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Setup AuthViewController
    private func createAndSetupAuthViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return AuthViewController() }
        authViewController.authViewControllerDelegate = self
        authViewController.modalPresentationStyle = .fullScreen
        return authViewController
    }
}

// MARK: - AuthViewControllerDelegate
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
            case .success(let token):
                self.fetchProfile(token)
            case .failure(let error):
                print(error.localizedDescription)
                self.showResults()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.fetchProfileImageURL(token)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                self.showResults()
                break
            }
        }
    }
    
    private func fetchProfileImageURL(_ token: String) {
        profileImageService.fetchProfileImageURL(
            username: profileService.profile?.username ?? " ",
            token: token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    print(url)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showResults()
                }
            }
    }
}

// MARK: - AlertPresenterDelegate
extension SplashViewController : AlertPresenterDelegate {
    
    func showResults() {
        
        alertPresenter?.sendAlertNetworkError(on: self)
    }
}
