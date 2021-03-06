import Foundation
import UIKit

private class InternalClass {}

extension Bundle {
    #if XCODE_FRAMEWORK
    @nonobjc
    internal static let framework = Bundle(for: InternalClass.self)
    #else
    @nonobjc
    internal static let framework = Bundle.module
    #endif

    public var appName: String? {
        if let appName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            // Localised app name
            return appName
        } else if let appName = object(forInfoDictionaryKey: "CFBundleName") as? String {
            // Regular app name
            return appName
        } else if let appName = object(forInfoDictionaryKey: "CFBundleExecutable") as? String {
            // Executable name
            return appName
        } else {
            return nil
        }
    }

    public var appVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    public var appBuild: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    internal var appIcon: UIImage? {
        return UIImage(named: "App Icon 128pt", in: self, compatibleWith: nil)
    }
}
