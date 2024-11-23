//
//  ImagesListPresenter.swift
//  setupProject
//
//  Created by Илья Дышлюк on 20.11.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    func setView(_ view: ImagesListViewControllerProtocol)
    func viewDidLoad()
    func didSelectPhoto(at indexPath: IndexPath)
    func toggleLike(for indexPath: IndexPath)
    
}

class ImagesListPresenter: ImagesListPresenterProtocol{
    
    private weak var view: ImagesListViewControllerProtocol?
    private var imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func setView(_ view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didSelectPhoto(at indexPath: IndexPath) {
        guard indexPath.row < imagesListService.photos.count else {
            print("IndexPath out of range")
            return
        }
        let photo = imagesListService.photos[indexPath.row]
        print("Did select photo at indexPath: \(indexPath)")
        view?.performSegueToSingleImage(with: photo)
    }
    
    func toggleLike(for indexPath: IndexPath) {
        print("Toggling like for indexPath: \(indexPath)")
        guard indexPath.row < imagesListService.photos.count else {
            print("IndexPath out of range")
            return
        }
        
        let photo = imagesListService.photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.updateCellLikeStatus(at: indexPath, isLiked: isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print("Failed to toggle like: \(error.localizedDescription)")
                }
            }
        }
    }
}
