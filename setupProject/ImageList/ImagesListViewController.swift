//
//  ViewController.swift
//  setupProject
//
//  Created by Илья Дышлюк on 02.03.2024.
//
import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController {
    private let showSingleImageSequeIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListControllerObserver: NSObjectProtocol?
    
    @IBOutlet
    private var tableView: UITableView!
    
    private var photos: [Photo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        observeImagesListControllerChanges()
        imagesListService.fetchPhotosNextPage()
    }
    
    private lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    
    private func observeImagesListControllerChanges() {
        imagesListControllerObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    deinit {
        if let observer = imagesListControllerObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSequeIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            
            let photo = photos[indexPath.row]
            viewController.fullImageURL = photo.fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates({
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
    
    
}


extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        
        let photo = photos[indexPath.row]
        cell.delegate = self // Устанавливаем контроллер в качестве делегата ячейки
        cell.configure(with: photo)
        
        return cell
    }
}

extension ImagesListViewController {
    func configCell(_ cell: ImagesListCell, with photo: Photo) {
        cell.dateLabel.text = dateFormatter.string(from: Date())
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSequeIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var photo = photos[indexPath.row]
        
        let isLiked = !photo.isLiked // Инвертируем текущее состояние лайка
        // Покажем лоадер
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Like status changed successfully")
                    photo.isLiked = isLiked
                    cell.updateLikeButton(isLiked: isLiked) // Обновляем только кнопку лайка в ячейке
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print("Failed to change like status: \(error.localizedDescription)")
                }
            }
        }
    }
}
