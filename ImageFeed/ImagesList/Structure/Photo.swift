//
//  Photo.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

import Foundation

struct Photo {
    let id: String?
    let size: CGSize?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool?
    
    init(id: String?, size: CGSize?, createdAt: Date?, welcomeDescription: String?, thumbImageURL: String?, largeImageURL: String?, isLiked: Bool?) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(_ photoResult: PhotoResult) {
        self.id = photoResult.id
       
        
        if let width = photoResult.width,
           let height = photoResult.height {
            self.size = CGSize(width: width, height: height)
        } else {
            self.size = CGSize(width: 400, height: 400)
        }
        
        if let createdAt = photoResult.createdAt {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            
            self.createdAt = formatter.date(from: createdAt)
        } else {
            self.createdAt = nil
        }
       

        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls?.thumb
        self.largeImageURL = photoResult.urls?.full
        self.isLiked = photoResult.likedByUser
    }
}
