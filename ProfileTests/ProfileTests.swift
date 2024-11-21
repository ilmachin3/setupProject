//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import XCTest
import UIKit
@testable import setupProject

class ProfileViewTests: XCTestCase {
    var spyView: ProfileViewSpy!
    var presenter: ProfilePresenter!
    var mockProfileImageService: MockProfileImageService!
    
    override func setUp() {
        super.setUp()
        spyView = ProfileViewSpy()
        mockProfileImageService = MockProfileImageService()
        presenter = ProfilePresenter(view: spyView,
                                     profileService: MockProfileService(),
                                     profileImageService: MockProfileImageService(),
                                     profileLogoutService: MockProfileLogoutService())
    }
    
    override func tearDown() {
        spyView = nil
        presenter = nil
        super.tearDown()
    }
    
    func testUpdateAvatar() {
        let avatarURL = mockProfileImageService.avatarURL ?? ""
        presenter.viewDidLoad()
        presenter.view?.updateAvatar(with: avatarURL)
        XCTAssertTrue(spyView.updateAvatarCalled, "updateAvatar called")
    }
    
    func testObserveProfileImageChanges() {
        let expectation = XCTestExpectation(description: "Profile image changes observed")
        let mockImageURL = mockProfileImageService.avatarURL ?? ""
        
        presenter.observeProfileImageChanges()
        
        // Симулирую изменение аватара
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil, userInfo: ["URL": mockImageURL])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            XCTAssertTrue(spyView.updateAvatarCalled, "updateAvatar called")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testResetUI() {
        presenter.resetUI()
        XCTAssertTrue(spyView.resetUICalled, "resetUI called")
    }
    
    func testUpdateProfileDetails() {
        let profile = ProfileService.Profile(userName: "JohnDoe", name: "John Doe", loginName: "@johndoe", bio: "Bio description")
        presenter.view = spyView

        presenter.viewDidLoad()
        presenter.view?.updateProfileDetails(profile)

        XCTAssertTrue(spyView.updateProfileDetailsCalled, "updateProfileDetails called")
        XCTAssertEqual(spyView.updatedProfile?.userName, "JohnDoe", "Correct profile should be passed to updateProfileDetails")
    }
}
