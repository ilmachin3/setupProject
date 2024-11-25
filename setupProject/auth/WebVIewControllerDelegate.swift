//
//  WebVIewControllerDelegate.swift
//  setupProject
//
//  Created by Илья Дышлюк on 05.05.2024.
//

import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewController)
}
