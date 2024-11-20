//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

@testable import setupProject
import XCTest

class ImagesListPresenterTests: XCTestCase {
    var presenter: ImagesListPresenter!
    var spyView: ImagesListViewControllerSpy!
    var mockService: MockImagesListService!
    
    override func setUp() {
        super.setUp()
        mockService = MockImagesListService()
        presenter = ImagesListPresenter(imagesListService: mockService)
        spyView = ImagesListViewControllerSpy()
        presenter.setView(spyView)
    }
    
    override func tearDown() {
        mockService = nil
        presenter = nil
        spyView = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockService.didFetchPhotosNextPage)
    }
    
    func testDidSelectPhoto() {
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didSelectPhoto(at: indexPath)
        XCTAssertTrue(spyView.performSegueCalled)
        
        // Создаю expectation для ожидания вызова метода performSegueToSingleImage
        let expectation = XCTestExpectation(description: "performSegueToSingleImageCalled")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Проверяю, что метод performSegueToSingleImage был вызван
            XCTAssertTrue(self.spyView.performSegueCalled)
            // Фиксирую выполнение expectation
            expectation.fulfill()
        }
        // Жду выполнения expectation в течение 2 секунд
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testToggleLike() {
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.toggleLike(for: indexPath)
        XCTAssertTrue(mockService.didChangeLikeCalled)

        // Создаю expectation для ожидания вызова метода updateCellLikeStatus
        let expectation = XCTestExpectation(description: "updateCellLikeStatusCalled")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Проверяю, что метод updateCellLikeStatus был вызван
            XCTAssertTrue(self.spyView.updateCellLikeStatusCalled)
            // Фиксирую выполнение expectation
            expectation.fulfill()
        }
        // Жду выполнения expectation в течение 2 секунд
        wait(for: [expectation], timeout: 2.0)
    }
}
