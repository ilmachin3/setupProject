//
//  MockProfileImageService.swift
//  ProfileTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import Foundation
@testable import setupProject

class MockProfileImageService: ProfileImageServiceProtocol {
    var avatarURL: String? = "https://example.com/avatar.jpg"
}
