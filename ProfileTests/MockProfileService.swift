//
//  MockProfileService.swift
//  ProfileTests
//
//  Created by Илья Дышлюк on 21.11.2024.
//

import Foundation
@testable import setupProject

class MockProfileService: ProfileServiceProtocol {
    var profile: ProfileService.Profile?
}
