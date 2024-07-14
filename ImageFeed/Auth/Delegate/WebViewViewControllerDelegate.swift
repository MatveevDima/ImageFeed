//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 14.07.2024.
//

import UIKit

protocol WebViewViewControllerDelegate : AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
