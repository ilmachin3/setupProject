//
//  WebViewViewControllerSpy.swift
//  ImageFeedTestsImage
//
//  Created by Илья Дышлюк on 20.11.2024.
//

import Foundation
import setupProject

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: (any setupProject.WebViewPresenterProtocol)?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
