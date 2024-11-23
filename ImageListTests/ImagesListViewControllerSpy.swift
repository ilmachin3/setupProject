//
//  ImagesListViewControllerSpy.swift
//  ImageListTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

@testable import setupProject
import Foundation

class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var setViewCalled: Bool = false
    var performSegueCalled: Bool = false
    var updateCellLikeStatusCalled = false
    var didSelectPhotoCalled = false
    var view: ImagesListViewControllerProtocol?
    
    func updateTableViewAnimated() {}
    
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        updateCellLikeStatusCalled = true
        print("SpyImagesListView - updateCellLikeStatus called")
    }
    
    func performSegueToSingleImage(with photo: setupProject.Photo) {
        performSegueCalled = true
    }
    
    func didSelectPhoto(at indexPath: IndexPath) {
        didSelectPhotoCalled = true
    }
    
    func setView(_ view: ImagesListViewControllerProtocol) {
        setViewCalled = true
        self.view = view
        print("setViewCalled is set to true")
        print("Set view to: \(view)")
    }
}
