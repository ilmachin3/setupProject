//
//  ImagesListPresenterSpy.swift
//  ImageListTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import Foundation
@testable import setupProject

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var didLoadCalled = false

    func setView(_ view: ImagesListViewControllerProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        didLoadCalled = true
    }

    func didSelectPhoto(at indexPath: IndexPath) {}

    func toggleLike(for indexPath: IndexPath) {}
}
