//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit
import Kingfisher

final class ProfileViewPresenter {
    
    weak var view: ProfileViewControllerProtocol?
    var alertPresenter: AlertPresenterProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profile: Profile?
}

extension ProfileViewPresenter : ProfileViewPresenterProtocol {
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard
                    let self = self
                else { return }
            
                self.updateProfileImage()
            }
    }
    
    func updateProfileInfo() {
        
        guard let profile = profileService.profile else { return }
        
        view?.setNameLabelText(profile.name ?? "")
        view?.setAccountLabelText(profile.loginName ?? "")
        view?.setDescriptionLabelText(profile.bio ?? "")
    }
    
    func updateProfileImage() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatar(avatar: url)
    }
    
    func exitButtonClicked() {
        guard let view = view as? UIViewController
        else { return }
        alertPresenter?.sendAlertDidClickedExitButton(on: view)
    }
}

extension ProfileViewPresenter : AlertPresenterDelegate {
    
    func showAlertNetworkError() {
        guard let view = view as? UIViewController
        else { return }
        alertPresenter?.sendAlertNetworkError(on: view)
    }
}
