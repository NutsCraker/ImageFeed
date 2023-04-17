//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 21.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    
    weak var delegate: AuthViewControllerDelegate?
    private let auth_screen_logo = UIImageView()
    private let button = UIButton()
    private let showWebView = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    
    private func makeUI() {
        view.backgroundColor = .ypBlack
        auth_screen_logo.image = UIImage(named: "AuthView")
        view.addSubview(auth_screen_logo)
        view.addSubview(button)
        auth_screen_logo.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .ypWhite
        
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonEntrance), for: .touchUpInside)
        button.accessibilityIdentifier = "Authenticate"
        
        NSLayoutConstraint.activate([
            auth_screen_logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            auth_screen_logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 343),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    @objc private func buttonEntrance() {
        if let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewPresenter.view = viewController
            viewController.presenter = webViewPresenter
            viewController.modalPresentationStyle = .fullScreen
            viewController.delegate = self
            present(viewController, animated: true)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
