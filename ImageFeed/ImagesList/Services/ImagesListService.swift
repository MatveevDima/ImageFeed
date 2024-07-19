//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 18.07.2024.
//

import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private init() {
        
    }
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    func cleanPhotos() {
        self.photos = []
    }
    
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
    // MARK: change like
extension ImagesListService {
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oAuth2TokenStorage.token else { return }
        let request = makeChangeLikeRequest(token: token, photoId: photoId, isLike: isLike)
        
        let urlSession = URLSession.shared
        
        let newLikeTask = urlSession.data(for: request) { [weak self] result in
          
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL, 
                        largeImageURL: photo.largeImageURL,
                        isLiked: !(photo.isLiked ?? false)
                    )
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        newLikeTask.resume()
    }
    
    private func makeChangeLikeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest {
        let baseURL = URL(string: Constants.defaultBaseApiURL)!
        let url = URL(
            string: "/photos/\(photoId)/like",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
