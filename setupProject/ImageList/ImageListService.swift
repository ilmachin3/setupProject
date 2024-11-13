//
//  ImageListService.swift
//  setupProject
//
//  Created by Илья Дышлюк on 13.11.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        // ...
    }
}

