//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
