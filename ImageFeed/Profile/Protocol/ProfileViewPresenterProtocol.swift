//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit

protocol ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    
    func updateProfileInfo()
    
    func updateProfileImage()
    
    func exitButtonClicked()
}
