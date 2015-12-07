//
//  AboutScreenUser.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import Foundation

public struct AboutScreenUser {
    public let displayName: String
    public let title: String
    public let twitterUsername: String?

    public init(displayName: String, title: String, twitterUsername: String?) {
        self.displayName = displayName
        self.title = title
        self.twitterUsername = twitterUsername
    }
}
