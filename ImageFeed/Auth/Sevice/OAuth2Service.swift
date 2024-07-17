//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit

class OAuth2Service {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> (Void)) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
        task?.cancel()
        lastCode = code
        
        self.fetch(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let oAuthTokenResponseBody):
                        let token = oAuthTokenResponseBody.accessToken
                        self?.oAuth2TokenStorage.token = token
                        completion(.success(token))
    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self?.task = nil
                self?.lastCode = nil
            }
        }
    }
    
    private func fetch(code: String, handler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        
        let request = makeOAuthTokenRequest(code: code)
        let urlSession = URLSession.shared
        let task = urlSession.objectTask(for: request, completion: handler)
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        let baseURL = URL(string: Constants.defaultBaseURL)!
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         )!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    enum AuthServiceError: Error {
        case invalidRequest
    }
}
