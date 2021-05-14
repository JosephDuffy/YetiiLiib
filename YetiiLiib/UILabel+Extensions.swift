import UIKit

extension UILabel {
    public convenience init(fontStyle: String) {
        self.init(frame: CGRect.zero)

        self.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: fontStyle))
    }

    public func currentFontStyle() -> String {
        if self.font.isEqual(UIFont.preferredFont(forTextStyle: .body)) {
            return UIFont.TextStyle.body.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .headline)) {
            return UIFont.TextStyle.headline.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .caption1)) {
            return UIFont.TextStyle.caption1.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .caption2)) {
            return UIFont.TextStyle.caption2.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .footnote)) {
            return UIFont.TextStyle.footnote.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .subheadline)) {
            return UIFont.TextStyle.subheadline.rawValue
        }
        return UIFont.TextStyle.body.rawValue
    }
}
