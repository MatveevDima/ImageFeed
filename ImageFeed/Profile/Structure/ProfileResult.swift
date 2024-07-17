//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 16.07.2024.
//

import UIKit

struct ProfileResult: Codable {
    
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
   
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
