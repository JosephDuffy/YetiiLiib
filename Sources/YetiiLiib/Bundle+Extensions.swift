import Foundation

private final class InternalClass {}

extension Bundle {

    internal static let framework = Bundle(for: InternalClass.self)

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

}
