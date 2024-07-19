//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

import Foundation

struct UrlsResult : Codable {
    
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
