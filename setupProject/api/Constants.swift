//
//  ProfileService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 31.05.2024.
//
import UIKit

enum Constants{
    static let AccessKey = "J5UYk2t_AZn4Ceh4PKVDrIcMiQeAsh_886mLvYa_NS0"
    static let SecretKey = "SekZF0l0XQWeiU7PxMqReTaN-N4Pbn5ElOIxek0hUvY"
    static let RedirectURL = "urn:ietf:wg:oauth:2.0:oob"
    
    static let AccessScope = "public+read_user+write_likes"
    static var DefaultBaseURL: URL? {
        return URL(string: "https://api.unsplash.com")
    }
}
