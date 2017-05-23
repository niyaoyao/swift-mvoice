//
//  AppDelegateExtension.swift
//  NYHealthy
//
//  Created by NiYao on 5/19/16.
//  Copyright © 2016 SuneBearNi. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    func setupRootViewController() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.rootViewController = ViewController() // Change rootViewController for what you need
        window!.makeKeyAndVisible()
    }
    
    func switchRootViewControllerTo(destinationController: UIViewController) {
        if window?.rootViewController == nil {
            window?.rootViewController = destinationController
            window?.makeKeyAndVisible()
        } else {
            if window?.rootViewController?.presentedViewController != nil {
                window?.rootViewController?.dismiss(animated: false, completion: {
                    self.window?.rootViewController = destinationController
                })
            } else {
                window?.rootViewController = destinationController
            }
        }
    }
    
    func setupAppearance() {
        setupWindowAppearance()
        setupTabBarAppearance()
        setupNavigationBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let tabBar:UITabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.hexValue(hex: 0x333333)
        tabBar.backgroundImage = UIImage.unitImageForColor(color: UIColor.white)
        tabBar.shadowImage = UIImage.unitImageForColor(color: UIColor.hexValue(hex: 0xffffff))
        tabBar.isTranslucent = true
    }
    
    private func setupNavigationBarAppearance() {
        let navigationBar:UINavigationBar = UINavigationBar.appearance()
        let tintColor = UIColor.hexValue(hex: 0x51D6A0)
        navigationBar.tintColor = tintColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:tintColor]
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage.unitImageForColor(color: UIColor.alphaValue(hex: 0xffffff, alpha: 0.8)), for: UIBarMetrics.default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0.0, -60.0), for: UIBarMetrics.default)
    }
    
    private func setupWindowAppearance() {
        window?.layer.cornerRadius = 5.0
        window?.layer.masksToBounds = true
    }
}
