//
//  GPHelper.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import UIKit


class GPHelper {
    
    static let shared = GPHelper()
    
    static func instantiateViewController<T: UIViewController>(type: T.Type) -> T {
        let storyboardName: String
        switch UIDevice.current.deviceSize {
        case .smallIphone:
            storyboardName = "Main_PhoneSmall"
        case .bigIphone:
            storyboardName = "Main"
        case .ipad:
            storyboardName = "MainIPad"
        }
        
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: PremiumViewController.self)).instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
    
}
