//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

import Foundation

struct PhotoResult : Codable {
    
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let description: String?
    let urls: UrlsResult?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case blurHash = "blur_hash"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}
