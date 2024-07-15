//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit

class OAuth2Service {
    
    func fetchOAuthToken(code: String, complition: @escaping (Result<String, Error>) -> (Void)) {
            self.fetch(code: code) { result in
                switch result {
                case .success(let data):
                    do {
                        let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        complition(.success(oAuthTokenResponseBody.accessToken))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    private func fetch(code: String, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = makeOAuthTokenRequest(code: code)
        let urlSession = URLSession.shared
        let task = urlSession.data(for: request, completion: handler)
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
}
