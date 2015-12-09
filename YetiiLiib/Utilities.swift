//
//  Utilities.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import Foundation

public class Utilities {
    public static var applicationBundle: NSBundle = NSBundle.mainBundle()
    public static var framworkBundle: NSBundle = NSBundle(forClass: Utilities.self)
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
            appIconImage = UIImage(named: "App Icon 128pt", inBundle: bundle, compatibleWithTraitCollection: nil)
        }

        return appIconImage
    }
}