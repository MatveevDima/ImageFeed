//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 19.07.2024.
//

import UIKit

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
       
       cleanCookies()
       
       ProfileService.shared.cleanProfile()
       ProfileImageService.shared.cleanProfileUrl()
       ImagesListService.shared.cleanPhotos()
       OAuth2TokenStorage.shared.deleteTokenFromKeyChain()
       
       
   }

   private func cleanCookies() {
      // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
    
