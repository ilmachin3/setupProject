//
//  ImagesListViewControllerTests.swift
//  ImageListTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

@testable import setupProject
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    var imagesListViewController: ImagesListViewController!
    var spyView: ImagesListViewControllerSpy!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        imagesListViewController.loadView()
        spyView = ImagesListViewControllerSpy()
        imagesListViewController.setView(spyView)
    }

    override func tearDown() {
        imagesListViewController = nil
        spyView = nil
        super.tearDown()
    }

    func testPerformSegueCalled() {
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: String(), welcomeDescription: "Test", thumbImageURL: "thumbURL", regularImageURL: "regularURL", fullImageURL: "fullURL", isLiked: false, user: User(id: "1", username: "testuser", name: "Test User", profileImageURL: "profileURL"))
        spyView.performSegueToSingleImage(with: photo)

        XCTAssertTrue(spyView.performSegueCalled, "performSegueToSingleImage should be called when performing segue")
    }
}
