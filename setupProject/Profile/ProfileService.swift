//
//  ProfileService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 31.05.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidURL
    case urlRequestError(Error)
    case urlSessionError
}

final class ProfileService {
    
    private(set) var profile: Profile?
    static let shared = ProfileService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    struct ProfileResult: Codable {
        let id: String
        let updatedAt: String
        let username: String
        let firstName: String?
        let lastName: String?
        let twitterUsername: String?
        let portfolioURL: URL?
        let bio: String?
        let location: String?
        let totalLikes: Int
        let totalPhotos: Int
        let totalCollections: Int
        let followedByUser: Bool
        let downloads: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case updatedAt = "updated_at"
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case twitterUsername = "twitter_username"
            case portfolioURL = "portfolio_url"
            case bio
            case location
            case totalLikes = "total_likes"
            case totalPhotos = "total_photos"
            case totalCollections = "total_collections"
            case followedByUser = "followed_by_user"
            case downloads
        }
        
        var updatedAtDate: Date? {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime]
            return dateFormatter.date(from: updatedAt)
        }
    }
    
    struct Profile {
        let userName: String
        let name: String
        let loginName: String
        let bio: String?
        
        init(userName: String, name: String, loginName: String, bio: String?) {
            self.userName = userName
            self.name = name
            self.loginName = loginName
            self.bio = bio
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeUrlRequest(endpoint: "https://api.unsplash.com/me", bearerToken: token) else {
            let urlRequestError = ProfileServiceError.invalidURL
            print("[fetchProfile]: Profile Service Error - \(urlRequestError)")
            completion(.failure(urlRequestError))
            return
        }
        
        if let task = self.task {
            task .cancel()
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case.success(let profileResult):
                let profile = Profile(
                    userName: profileResult.username,
                    name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines),
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio)
                self.profile = profile
                completion(.success(profile))
            case.failure(_):
                let invalidSessionError = ProfileServiceError.urlSessionError
                print("[objectTask]: Profile Service Error - \(invalidSessionError)")
                completion(.failure(invalidSessionError))
            }
        }
        task.resume()
        self.task = task
    }
    func resetProfile() {
        profile = nil
    }
    
    private func makeUrlRequest(endpoint: String, bearerToken: String) -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
        
    }

}
