//
//  Utilities.swift
//  FirebaseApp
//
//  Created by Moroz Pavlo on 2023-03-22.
//

import Foundation
import UIKit

final class  Utilities {
    
    @MainActor
    class func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
