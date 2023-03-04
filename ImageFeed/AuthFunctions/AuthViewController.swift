//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 04.03.2023.
//

import UIKit
class AuthViewController: UIViewController {
    
    
    weak var delegate: AuthViewControllerDelegate?
    private let auth_screen_logo = UIImageView()
    private let button = UIButton()
    private let showWebView = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebView {
            let viewController = segue.destination as! WebViewViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
    
    @objc func buttonEntrance() {
        performSegue(withIdentifier: showWebView, sender: nil)
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
