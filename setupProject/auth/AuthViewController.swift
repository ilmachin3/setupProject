//
//  ProfileService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 31.05.2024.

import UIKit

final class AuthViewController: UIViewController {
    
    private let oauth2service = OAuth2Service.shared
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewController = segue.destination as? WebViewController else {
                assertionFailure("failed to cast destination view controller to WebViewViewController")
                return
            }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

    // MARK: - Extension

extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                print("Received access token: \(token)")
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                UIBlockingProgressHUD.dismiss()
            case.failure(let error):
                print("Error fetching access token: \(error)")
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}
