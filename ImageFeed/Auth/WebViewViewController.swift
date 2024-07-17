//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 14.07.2024.
//

import UIKit
import WebKit

final class WebViewViewController : UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(
                   \.estimatedProgress,
                   options: [],
                   changeHandler: { [weak self] _, _ in
                       guard let self = self else { return }
                       self.updateProgress()
                   })
        
        loadAuthView()
    }

    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.authorizeURLString) else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
         ]

        guard let url = urlComponents.url else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
        }

    private func updateProgress() {
        progressBar.progress = Float(webView.estimatedProgress)
        progressBar.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let codeItem = code(from: navigationAction) {
                decisionHandler(.cancel)
                delegate?.webViewViewController(self, didAuthenticateWithCode: codeItem)
          } else {
                decisionHandler(.allow)
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value                                         
        } else {
            return nil
        }
    }
}
