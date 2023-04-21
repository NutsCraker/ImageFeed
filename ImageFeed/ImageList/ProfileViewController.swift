//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 03.02.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func makeUI()
    func showAlert()
    var profileName: UILabel { get set }
    var profileContact: UILabel { get set }
    var profileAbout: UILabel { get set }
    
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profilePhoto = UIImageView()
    var profileName = UILabel()
    var profileContact = UILabel()
    var profileAbout = UILabel()
    private let logOutButton = UIButton.systemButton(with: UIImage(named: "logout")!, target: nil, action: #selector(Self.didTapButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.accessibilityIdentifier = "logoutButton"
        
        presenter = ProfilePresenter()
        presenter?.view = self
        presenter?.setUI()
        
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    func makeUI() {
        view.backgroundColor = .ypBlack
        
        let allViewOnScreen = [profilePhoto, profileName, profileContact, profileAbout, logOutButton]
        allViewOnScreen.forEach {view.addSubview($0)}
        allViewOnScreen.forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        
        profileName.font = UIFont.boldSystemFont(ofSize: 23)
        profileName.textColor = .ypWhite
        
        profileContact.font = UIFont.systemFont(ofSize: 13)
        profileContact.textColor = .ypGray
        
        profileAbout.font = UIFont.systemFont(ofSize: 13)
        profileAbout.textColor = .ypWhite
        
        logOutButton.tintColor = .ypRed
        
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileName.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileName.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            profileAbout.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileAbout.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileContact.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileContact.topAnchor.constraint(equalTo: profileAbout.bottomAnchor, constant: 8),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapButton() {
        showAlert()
    }
}

extension ProfileViewController {
    func updateAvatar() {
        guard let url = presenter?.getUrlForProfileImage() else { return  }
        let processor = RoundCornerImageProcessor(cornerRadius: 50, backgroundColor: .clear)
        profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        profilePhoto.kf.indicatorType = .activity
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.presenter?.exit()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
        
        alert.view.accessibilityIdentifier = "exit"
    }
}

