//
//  ImageListService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 13.11.2024.
//

import Foundation

enum ImagesListServiceError: Error {
    case urlError
    case failedToFetchPhotos
    case urlRequestError
}

struct User {
    let id: String
    let username: String
    let name: String
    let profileImageURL: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let regularImageURL: String
    let fullImageURL : String
    var isLiked: Bool
    let user: User
}


struct PhotoResult: Codable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let description: String?
    let liked_by_user: Bool?
    let urls: UrlsResult
    let user: UserResult
    
//    var createdAtDate: Date? {
//        let dateFormatter = ISO8601DateFormatter()
//        dateFormatter.formatOptions = [.withInternetDateTime]
//        return dateFormatter.date(from: created_at)
//    }
}

struct UserResult: Codable {
    let id: String
    let username: String
    let name: String
    let profile_image: ProfileImage
}

struct ProfileImage: Codable {
    let medium: String
}

struct UrlsResult: Codable {
    let thumb: String
    let regular: String
    let full: String
}

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    
    private var lastLoadedPage: Int?
    private var isFetching: Bool = false
    
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    private func makeUrlRequest(forPage page: Int) -> URLRequest? {
        guard let accessToken = tokenStorage.token else {
            print("Token is nil")
            return nil
        }
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=10&access_token=\(accessToken)")  else {
            let urlError = ImagesListServiceError.urlError
            print("[makeUrlRequest]: ImagesListServiceError - \(urlError)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    
    func numberOfLoadedPhotos() -> Int {
        return photos.count
    }
    
    func fetchPhotosNextPage() {
        
        guard !isFetching else { return } // Проверяем, не выполняется ли уже загрузка
        
        isFetching = true // Устанавливаем флаг, что начали загрузку
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeUrlRequest(forPage: nextPage) else {
            let urlRequestError = ImagesListServiceError.urlRequestError
            print("[fetchPhotosNextPage]: ImagesListServiceError - \(urlRequestError)")
            return
            
        }
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result <[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                let photos  = photoResults.map { photoResult in
                    let user = User(
                        id: photoResult.user.id,
                        username: photoResult.user.username,
                        name: photoResult.user.name,
                        profileImageURL: photoResult.user.profile_image.medium
                    )
                    return Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: photoResult.created_at,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        regularImageURL: photoResult.urls.regular,
                        fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.liked_by_user ?? false,
                        user: user
                    )
                }
                let uniquePhotos = photos.filter { newPhoto in
                    !self.photos.contains { existingPhoto in
                        existingPhoto.id == newPhoto.id // Проверяем, есть ли в массиве уже фотография с таким же id
                    }
                }
                self.photos.append(contentsOf: uniquePhotos)
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            case .failure(_):
                let failedToFetchPhotos = ImagesListServiceError.failedToFetchPhotos
                print("[fetchPhotosNextPage]: ImagesListServiceError - \(failedToFetchPhotos)")
            }
            self.isFetching = false
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = tokenStorage.token else {
            print("Token is nil")
            completion(.failure(URLError(.notConnectedToInternet)))
            return
        }
        
        let httpMethod = isLiked ? "POST" : "DELETE"
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ImagesListServiceError.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "ImagesListService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to change like status"])))
                return
            }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                var updatedPhoto = self.photos[index]
                updatedPhoto.isLiked = isLiked
                self.photos[index] = updatedPhoto
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    func resetImagesList() {
        photos.removeAll()
        lastLoadedPage = nil
        isFetching = false
    }
}
