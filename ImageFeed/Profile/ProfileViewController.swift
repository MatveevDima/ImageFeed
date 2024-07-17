//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 12.07.2024.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    var profileImage: UIImageView!
    var exitButton: UIButton!
    var nameLabel: UILabel!
    var accountLabel: UILabel!
    var descriptionLabel: UILabel!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private var profileImageUrls: ProfileImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        guard let profile = profileService.profile else { return }
        
        nameLabel.text = profile.name
        accountLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        DispatchQueue.main.async {
            let processor = RoundCornerImageProcessor(cornerRadius: 50)
            self.profileImage.kf.indicatorType = .activity
            self.profileImage.kf.setImage(with: url,
                                     options: [
                                        .processor(processor)
                                    ]
            )
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache()
        }
    }
    
    
    // MARK: - Actions
    
    @objc
    func exitButtonClicked() {
    }
    
    
    // MARK: - Setup View
    private func setupView() {
        setupSuperView()
        setupProfileImageView()
        setupExitButton()
        setupNameLabel()
        setupAccountLabel()
        setupDescriptionLabel()
    }
    
    private func setupSuperView() {
        view.backgroundColor = UIColor(named: "YP Black") ?? UIColor.black
    }
    
    private func setupProfileImageView() {
        profileImage = UIImageView(image: UIImage(named: "placeholder")!)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.tintColor = .none
        profileImage.layer.cornerRadius = 50
        
        view.addSubview(profileImage)
        
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupNameLabel() {
        
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 23)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupAccountLabel() {
        
        accountLabel = UILabel()
        accountLabel.text = "@ekaterina_nov"
        accountLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 13)
        accountLabel.textColor =  UIColor(named: "YP Grey") ?? UIColor.gray
        
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountLabel)
        
        accountLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        accountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupDescriptionLabel() {
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 13)
        descriptionLabel.textColor = .white
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupExitButton() {
        
        exitButton = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(Self.exitButtonClicked)
        )
        exitButton.tintColor = UIColor(named: "YP Red") ?? UIColor.red
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }
}
