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
    
    var presenter: WebViewPresenterProtocol?
    
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
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
        
        presenter?.viewDidLoad()
    }
    
    func setProgressValue(_ newValue: Float) {
        progressBar.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressBar.isHidden = isHidden
    }
}

    // MARK: WebViewViewControllerProtocol
extension WebViewViewController : WebViewViewControllerProtocol {
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}

    // MARK: WKNavigationDelegate
extension WebViewViewController : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url,
           let codeItem = presenter?.code(from: url) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: codeItem)
        } else {
            decisionHandler(.allow)
        }
    }
}
