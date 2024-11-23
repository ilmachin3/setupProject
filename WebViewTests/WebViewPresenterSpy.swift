//
//  WebViewPresenterSpy.swift
//  ImageFeedTestsImage
//
//  Created by Илья Дышлюк on 20.11.2024.
//

import Foundation
import setupProject

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: (any setupProject.WebViewViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
