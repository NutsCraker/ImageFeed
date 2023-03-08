//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 04.03.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    private let oAuth2Service = OAuth2Service()
    private var alertPresenter = AlertPresenter()
    private var alertMessage = AlertModel.self
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OAuth2TokenStorage().token != nil {
            self.switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController else {  assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code, completion: {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.switchToTabBarController()
                    ProgressHUD.dismiss()
                    self.dismiss(animated: true)
                case .failure(let error):
                    ProgressHUD.dismiss()
                    let alertMessage = AlertModel(title: "Что-то пошли нитак!",
                                                  message: error.localizedDescription,
                                                  buttonText: "Попробовать еще раз",
                                                  completion: { [weak self] _ in
                        guard let self = self else {
                            return }
                        self.viewDidAppear(true)
                    })
                    self.alertPresenter.show(result: alertMessage)
                }
            }
        })
    }}
