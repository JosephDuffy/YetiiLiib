//
//  Utilities.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public class Utilities {
    public static var applicationBundle: NSBundle = NSBundle.mainBundle()
    public static var assetsBundle: NSBundle = NSBundle(forClass: Utilities.self)
    public static var appIconImage: UIImage?

    public static func getAppName(bundle: NSBundle = Utilities.applicationBundle) -> String {
        if let appName = bundle.objectForInfoDictionaryKey("CFBundleDisplayName") as? String {
            // Localised app name
            return appName
        } else if let appName = bundle.objectForInfoDictionaryKey("CFBundleName") as? String {
            // Regular app name
            return appName
        } else if let appName = bundle.objectForInfoDictionaryKey("CFBundleExecutable") as? String {
            // Executable name
            return appName
        }
        return "Yetii App"
    }

    internal static func image(imageName imageName: String, inBundle bundle: NSBundle = Utilities.applicationBundle) -> UIImage? {
        if #available(iOS 8.0, *) {
            if let image = UIImage(named: imageName, inBundle: bundle, compatibleWithTraitCollection: nil) {
                return image
            } else {
                return nil
            }
        } else {
            // The bundle is ignored on iOS 7 because YetiiLiib can only be included
            // directly (e.g., with CocoaSeeds), so looking for the image in the
            // main bundle is the only option
            guard let image = UIImage(named: imageName) else {
                print("Failed to create UIImage named \(imageName)")
                return nil
            }

            return image
        }
    }

    public static func getAppVersion(bundle: NSBundle = Utilities.applicationBundle) -> String {
        return bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }

    public static func getAppBuild(bundle: NSBundle = Utilities.applicationBundle) -> String {
        return bundle.objectForInfoDictionaryKey("CFBundleVersion") as! String
    }

    public static func getAppBundleId(bundle: NSBundle = Utilities.applicationBundle) -> String? {
        return bundle.bundleIdentifier
    }

    public static func getAboutScreenAppIconImage(bundle: NSBundle = Utilities.applicationBundle) -> UIImage? {
        if appIconImage == nil {
            appIconImage = Utilities.image(imageName: "App Icon 128pt", inBundle: bundle)
        }

        return appIconImage
    }
}