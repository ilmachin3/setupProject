//
//  MockImagesListService.swift
//  ImageListTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

@testable import setupProject
import Foundation
import XCTest


class MockImagesListService: ImagesListServiceProtocol {
    
    var photos: [setupProject.Photo] = []
    var didFetchPhotosNextPage = false
    var didChangeLikeCalled = false
    
    init() {
            // Загрузка тестовых данных
            photos = [
                Photo(id: "1",
                      size: CGSize(width: 100, height: 100),
                      createdAt: String(),
                      welcomeDescription: "Test",
                      thumbImageURL: "thumbURL",
                      regularImageURL: "regularURL",
                      fullImageURL: "fullURL",
                      isLiked: false,
                      user: User(
                        id: "1",
                        username: "testuser",
                        name: "Test User",
                        profileImageURL: "profileURL"))
                ]
                }
                
    func fetchPhotosNextPage() {
        didFetchPhotosNextPage = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didChangeLikeCalled = true
        completion(.success(()))
        print("MockImagesListService - changeLike called")
    }
}


