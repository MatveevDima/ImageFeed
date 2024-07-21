//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
