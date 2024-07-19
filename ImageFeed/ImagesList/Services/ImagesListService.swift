//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

import UIKit

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if (task != nil) {
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = oAuth2TokenStorage.token else { return }
        let request = makeImageListRequest(token: token, page: nextPage)
        
        let urlSession = URLSession.shared
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResultBody):
                    let photos = photoResultBody.map { photoResult in
                        Photo(photoResult)
                    }
                    
                    self?.updatePhotoArray(photos)
                    self?.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos" : self?.photos]
                    )
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.task = nil
            }
        }
        
        self.task = task
        task.resume()
        
    }
    
    private func updatePhotoArray(_ photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }
    
    private func makeImageListRequest(token: String, page: Int) -> URLRequest {
        let baseURL = URL(string: Constants.defaultBaseApiURL)!
        let url = URL(
            string: "/photos"
            + "?page=\(page)"
            + "&&per_page=10",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
