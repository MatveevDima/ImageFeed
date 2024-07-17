//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 16.07.2024.
//

import UIKit


struct ProfileImage : Decodable {
    let profileImage: Urls?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct Urls : Decodable {
    let small: String?
    let medium: String?
    let large: String?
}
