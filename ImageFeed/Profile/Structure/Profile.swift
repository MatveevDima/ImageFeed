//
//  struct Profile.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 16.07.2024.
//
import UIKit

struct Profile: Codable {
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = profileResult.name
        self.loginName = "@\(profileResult.username ?? "unknown")"
        self.bio = profileResult.bio
    }
    
    let username: String?
    let name: String?
    let loginName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case loginName = "login_name"
        case bio = "bio"
    }
}
