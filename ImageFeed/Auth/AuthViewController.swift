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
    private let showWebViewSegueIdentifier = "ShowWebView"

    private let oAuth2TokenStorage : OAuth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
