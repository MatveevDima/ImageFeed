//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, code: String)
}
