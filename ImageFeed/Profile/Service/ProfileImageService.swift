//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 17.07.2024.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
        
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    private init () {}
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeProfileImageRequest(username: username, token: token)
        
        let urlSession = URLSession.shared
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImage, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileImageBody):
                        guard let profileImageSmall = profileImageBody.profileImage?.large else { return }
                        self?.avatarURL = profileImageSmall
                        completion(.success(profileImageSmall))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                userInfo: ["URL": profileImageSmall])
    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self?.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func makeProfileImageRequest(username: String, token: String) -> URLRequest {
        
        let baseURL = URL(string: Constants.defaultBaseApiURL)!
         let url = URL(
             string: "/users"
             + "/\(username)",
             relativeTo: baseURL
         )!
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         return request
    }
}
