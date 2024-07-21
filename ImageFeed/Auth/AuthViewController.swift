//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 14.07.2024.
//

import UIKit

class AuthViewController : UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    weak var authViewControllerDelegate: AuthViewControllerDelegate?
    private var alertPresenter: AlertPresenterProtocol?
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    private let oAuth2TokenStorage : OAuth2TokenStorage = OAuth2TokenStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        configureBackButton()
    }
    
    @IBAction func didSignInButtonTap(_ sender: Any) {
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack") ?? UIColor.black
    }
    
}

extension AuthViewController : WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true)
        authViewControllerDelegate?.didAuthenticate(self, code: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
        showResults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            let webViewPresenter = WebViewPresenter(authHelper: AuthHelper(configuration: AuthConfiguration.standard))
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController : AlertPresenterDelegate {
    
    func showResults() {
        
        alertPresenter?.sendAlertNetworkError(on: self)
    }
}
