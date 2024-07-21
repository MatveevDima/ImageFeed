//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest) 
    
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
