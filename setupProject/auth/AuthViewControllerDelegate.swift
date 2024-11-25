//
//  AuthViewControllerDelegate.swift
//  setupProject
//
//  Created by Илья Дышлюк on 05.05.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
