//
//  PhotoLibraryHelper.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 10.12.2022.
//

import Foundation
import Photos
import UIKit

final class PhotoAuthHelper {
    
    class func photoLibraryAuth(_ completion: @escaping (Bool) -> Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()

        switch authStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        default:
            completion(false)
        }
    }
}
