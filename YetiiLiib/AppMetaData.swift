//
//  AppMetaData.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 08/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import Foundation

public struct AppMetaData {
    public let appId: Int
    public let bundleId: String
    public let name: String
    public let formattedPrice: String
    public let artworkURL60: NSURL
    public let artworkURL100: NSURL
    public let artworkURL512: NSURL

    public init?(rawInformation: [String : AnyObject]) {
        // Mac apps don't return the "supportedDevices" field and can be filtered as such
        guard rawInformation["supportedDevices"] != nil else { return nil }
        // Ensure basic required information is available
        guard let appId = rawInformation["trackId"] as? Int else { return nil }
        guard let bundleId = rawInformation["bundleId"] as? String else { return nil }
        guard let name = rawInformation["trackName"] as? String else { return nil }
        guard let formattedPrice = rawInformation["formattedPrice"] as? String else { return nil }
        guard let artworkURL60String = rawInformation["artworkUrl60"] as? String else { return nil }
        guard let artworkURL60 = NSURL(string: artworkURL60String) else { return nil }
        guard let artworkURL100String = rawInformation["artworkUrl100"] as? String else { return nil }
        guard let artworkURL100 = NSURL(string: artworkURL100String) else { return nil }
        guard let artworkURL512String = rawInformation["artworkUrl512"] as? String else { return nil }
        guard let artworkURL512 = NSURL(string: artworkURL512String) else { return nil }

        self.appId = appId
        self.bundleId = bundleId
        self.name = name
        self.formattedPrice = formattedPrice
        self.artworkURL60 = artworkURL60
        self.artworkURL100 = artworkURL100
        self.artworkURL512 = artworkURL512
    }

    public func imageForSize(size: CGSize, applyIconRounding: Bool = true, scale: CGFloat = UIScreen.mainScreen().scale, callback: (UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let minWidth = size.width * scale
            let minHeight = size.height * scale
            let minSize = max(minWidth, minHeight)

            let url: NSURL = {
                if minSize <= 60 {
                    return self.artworkURL60
                } else if minSize <= 100 {
                    return self.artworkURL100
                } else {
                    return self.artworkURL512
                }
            }()

            if let data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                let imageToReturn: UIImage?

                if applyIconRounding {
                    imageToReturn = image.imageAfterApplyingAppIconMask()
                } else {
                    imageToReturn = image
                }

                dispatch_async(dispatch_get_main_queue()) {
                    callback(imageToReturn)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    callback(nil)
                }
            }
        }
    }

    /**
     Generates the App Store URL for the application

     - SeeAlso: [https://analytics.itunes.apple.com/#/campaigngenerator](https://analytics.itunes.apple.com/#/campaigngenerator)
     - SeeAlso: [https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns](https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns)

     - Parameter campaignProviderId: An optional campaign provider id (pt)
     - Parameter campaignToken: An optional campaign token (ct)

     - Throws:
     - `URLGenerationError.ParamterEncodingFailure` if one of the parameters fails
     to encode correctly
     - `URLGenerationError.InvalidURLString` if the generated URL string does not
     parse via the NSURL(string:) constructor

     - Returns: The generated url
     */
    public func appStoreURL(campaignProviderId campaignProviderId: Int?, campaignToken: String?) throws -> NSURL {
        var url = "itms-apps://itunes.apple.com/app/apple-store/id\(self.appId)"
        var hasAddedParameter = false

        func addParamter(name: String, value: String) throws {
            guard let encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) else {
                throw URLGenerationError.ParamterEncodingFailure(name: name, value: value)
            }

            if hasAddedParameter {
                url += "&"
            } else {
                url += "?"
                hasAddedParameter = true
            }

            url += "\(name)=\(encodedValue)"
        }

        if let campaignProviderId = campaignProviderId {
            try addParamter("pt", value: "\(campaignProviderId)")
        }

        if let campaignToken = campaignToken {
            if campaignToken.characters.count > 40 {
                throw URLGenerationError.CampaignTokenTooLong
            }
            try addParamter("ct", value: campaignToken)
        }

        try addParamter("mt", value: "8")

        if let url = NSURL(string: url) {
            return url
        } else {
            throw URLGenerationError.InvalidURLString(url: url)
        }
    }
}

public enum URLGenerationError: ErrorType {
    case InvalidURLString(url: String)
    case ParamterEncodingFailure(name: String, value: String)
    case CampaignTokenTooLong
}

extension URLGenerationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .InvalidURLString(let url):
            return"Failed to generate URL with string: \(url)"
        case .ParamterEncodingFailure(let name, let value):
            return "Failed to encode paramter \(name) value \(value)"
        case .CampaignTokenTooLong:
            return "Campaign Token must be 40 characters or less"
        }
    }
}