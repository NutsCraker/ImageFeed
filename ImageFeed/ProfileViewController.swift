//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 17.02.2023.
//


import UIKit

final class ProfileViewController: UIViewController {
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
    }
}
extension ProfileViewController {
    func addProfileImageView() {
        let profileImage = UIImage(named: "ava")
        profileImageView = UIImageView(image: profileImage)
        guard let profileImageView = profileImageView else {
            return
        }
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    func addNameLabel() {
        nameLabel = UILabel()
        guard let nameLabel = nameLabel else {
            return
        }
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    func addLoginNameLabel() {
        loginNameLabel = UILabel()
        guard let loginNameLabel = loginNameLabel else {
            return
        }
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = .yPGray
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    func addDescriptionLabel() {
        descriptionLabel = UILabel()
        guard let descriptionLabel = descriptionLabel else {
            return
        }
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    func addLogoutButton() {
        let buttonImage = UIImage(named: "logout_button")
        
        let logoutButtonView = UIButton.systemButton(with: buttonImage!,
                                               target: nil,
                                               action: nil)
        logoutButtonView.tintColor = .yPRed
        logoutButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButtonView)
        NSLayoutConstraint.activate([
            logoutButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            logoutButtonView.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor)
        ])

    }
}
