import Foundation

public struct AboutScreenUser {
    public struct Link {
        public let title: String
        public let url: URL
        public let alwaysOpenExternally: Bool

        public init(title: String, url: URL, alwaysOpenExternally: Bool) {
            self.title = title
            self.url = url
            self.alwaysOpenExternally = alwaysOpenExternally
        }
    }

    public let displayName: String
    public let title: String
    public let link: Link?

    public init(displayName: String, title: String, link: Link?) {
        self.displayName = displayName
        self.title = title
        self.link = link
    }
}
