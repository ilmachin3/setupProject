//
//  ProfileService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 31.05.2024.
//
import UIKit

import Kingfisher

final class ProfileViewController: UIViewController {
    
    let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        view.backgroundColor = .ypBlack
        
        setupUI()
        updateAvatar()
        addLogoutButton()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile)
        }
        
        observeProfileImageChanges()
    }
    
    private func setupUI() {
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        //NAME
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.numberOfLines = 0
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // LOGIN
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        usernameLabel.textColor = .ypGray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        usernameLabel.numberOfLines = 0
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //DESCRIPTION
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addLogoutButton() {
        guard let logoutImage = UIImage(systemName: "ipad.and.arrow.forward") else {
            return
        }

        let logoutButton = UIButton.systemButton(
            with: logoutImage,
            target: self,
            action: #selector(self.didTapButton)
        )

        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func observeProfileImageChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        //        updateAvatar()
    }
    
    private func updateProfileDetails(_ profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        usernameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? ""
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .transition(.fade(0.5))
            ],
            completionHandler: { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("Failed to load Image: \(error)")
                }
            }
        )
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc
       private func didTapButton() {
           
           let alertController = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           let logoutAction = UIAlertAction(title: "Выход", style: .destructive) { [weak self] _ in
               ProfileLogoutService.shared.logout()
               self?.resetUI()
           }
           
           alertController.addAction(logoutAction)
           present(alertController, animated: true, completion: nil)
       }
       
       private func resetUI() {
           nameLabel.text = ""
           usernameLabel.text = ""
           descriptionLabel.text = ""
           imageView.image = nil
       }
   }
