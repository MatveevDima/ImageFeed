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
    
    var presenter : ProfileViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
        presenter?.updateProfileInfo()
        presenter?.updateProfileImage()
    }
    
    // MARK: - Actions
    @objc
    func exitButtonClicked() {
        presenter?.exitButtonClicked()
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

    // MARK: - ProfileViewControllerProtocol
extension ProfileViewController : ProfileViewControllerProtocol {
    
    
    func setNameLabelText(_ newValue: String) {
        nameLabel.text = newValue
    }
    
    func setAccountLabelText(_ newValue: String) {
        accountLabel.text = newValue
    }
    
    func setDescriptionLabelText(_ newValue: String) {
        descriptionLabel.text = newValue
    }
    
    func setAvatar(avatar url: URL) {
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor(cornerRadius: 50))])
    }
}
