//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 16.07.2024.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private init() {
        
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeProfileRequest(token: token)
        
        let urlSession = URLSession.shared
        
        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let profileResultBody = try JSONDecoder().decode(ProfileResult.self, from: data)
                        
                        let profile = Profile(profileResult: profileResultBody)
                        self?.updateProfileDetails(profile)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self?.task = nil
            }
        }
        
        self.task = task
        task.resume()
        
    }
    
    private func updateProfileDetails(_ profile: Profile) {
        self.profile = profile
    }
    
    private func makeProfileRequest(token: String) -> URLRequest {
        let baseURL = URL(string: Constants.defaultBaseApiURL)!
         let url = URL(
             string: "/me",
             relativeTo: baseURL
         )!
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         return request
     }
    
    enum AuthServiceError: Error {
        case invalidRequest
    }
}
