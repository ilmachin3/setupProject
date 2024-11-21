//
//  ProfileViewSpy.swift
//  ProfileTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import Foundation
import XCTest
@testable import setupProject

class ProfileViewSpy: ProfileViewProtocol {
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var resetUICalled = false
    var updatedProfile: ProfileService.Profile?
    var presentedAlertController: UIViewController?

    func updateProfileDetails(_ profile: ProfileService.Profile) {
        updateProfileDetailsCalled = true
        updatedProfile = profile
    }

    func updateAvatar(with imageURL: String) {
        updateAvatarCalled = true
    }

    func resetUI() {
        resetUICalled = true
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentedAlertController = viewControllerToPresent as? UIAlertController
        // Do not call present here to avoid recursion
        // You can call completion block if needed
        completion?()
    }
}
