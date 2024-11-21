//
//  ProfilePresenter.swift
//  setupProject
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import Foundation

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func observeProfileImageChanges()
    func showLogoutAlert(in viewController: ProfileViewController)
    func resetUI()
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewProtocol? = nil, profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, profileLogoutService: ProfileLogoutServiceProtocol, profileImageServiceObserver: NSObjectProtocol? = nil) {
        self.view = view
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
        self.profileImageServiceObserver = profileImageServiceObserver
    }
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile)
        }
        observeProfileImageChanges()
        updateAvatar()
    }
    
    func showLogoutAlert(in viewController: ProfileViewController) {
        let alertController = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Выход", style: .destructive) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            self?.resetUI()
        }
        
        alertController.addAction(logoutAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func resetUI() {
        view?.resetUI()
    }
    
    func observeProfileImageChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL else {
            return
        }
        view?.updateAvatar(with: profileImageURL)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
