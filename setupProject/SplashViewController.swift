//
//  ProfileService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 1.06.2024.
//
import UIKit

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupUI()
        
    }
    
    private func setupUI() {
           let logoImage = UIImage(named: "ImageLogo")
           let logoView = UIImageView(image: logoImage)
           logoView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(logoView)
           logoView.contentMode = .scaleAspectFit
           
           NSLayoutConstraint.activate([
               logoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
               logoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
           ])
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            navigateToAuthScreen()
        }
    }
    
    private func navigateToAuthScreen() {
        if let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        } else {
            // Обработка ошибок: AuthViewController не найден
            print("Ошибка: Не удалось найти AuthViewController в Storyboard.")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - Extensions

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard self != nil else { return }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.switchToTabBarController() //переключение экрана
                }
            case .failure(let error):
                print("[SplashViewController]: Error fetching OAuth token - \(error)")
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauth2TokenStorage.token else {
            return
        }     //?????????
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss() // ?
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                    self.fetchProfileImage(profile.userName)
               }
            case .failure (let error):
                print("[SplashViewController]: Error fetching profile - \(error)")
            }
        }
    }
    
    private func fetchProfileImage(_ username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) {_ in }
    }
}
