//
//  AlertPresenterDelegate.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 06.03.2023.
//

import UIKit
protocol AlertPresenterDelegate: AnyObject {
    func didPresentAlert(alert: UIAlertController?)
}
