//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 06.03.2023.
//
import UIKit

struct AlertModel {
    let title : String
    let message : String
    let buttonText : String
    let completion: ((UIAlertAction) -> Void)
}
