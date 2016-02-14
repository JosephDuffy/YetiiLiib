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
            guard let imagePath = bundle.pathForResource(imageName, ofType: "pdf") else {
                print("Failed to get path for \(imageName)")
                return nil
            }

            guard let image = UIImage(contentsOfFile: imagePath) else {
                print("Failed to create UIImage from content of \(imageName) file at path: \(imagePath)")
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