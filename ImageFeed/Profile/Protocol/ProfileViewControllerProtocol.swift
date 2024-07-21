//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit

protocol ProfileViewControllerProtocol : AnyObject  {
    
    func setNameLabelText(_ newValue: String)
    func setAccountLabelText(_ newValue: String)
    func setDescriptionLabelText(_ newValue: String)
    func setAvatar(avatar url: URL)
}
