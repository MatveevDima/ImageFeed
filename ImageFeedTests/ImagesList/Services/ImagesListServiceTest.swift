//
//  ImagesListServiceTest.swift
//  ImageFeedTests
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper

// govno ebanoe a ne test
let AUTHTOKEN = "jv1JvENLvZ4CzN7IiBrZ2VLzefdGMr5OkJAJO1SkGP8"

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService.shared
        KeychainWrapper.standard.set(AUTHTOKEN, forKey: OAuth2TokenStorage.shared.bearerTokenKey)
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
