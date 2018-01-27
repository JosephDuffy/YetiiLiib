import UIKit

extension UILabel {
    public convenience init(fontStyle: String) {
        self.init(frame: CGRect.zero)

        self.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: fontStyle))
    }

    public func currentFontStyle() -> String {
        if self.font.isEqual(UIFont.preferredFont(forTextStyle: .body)) {
            return UIFontTextStyle.body.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .headline)) {
            return UIFontTextStyle.headline.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .caption1)) {
            return UIFontTextStyle.caption1.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .caption2)) {
            return UIFontTextStyle.caption2.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .footnote)) {
            return UIFontTextStyle.footnote.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: .subheadline)) {
            return UIFontTextStyle.subheadline.rawValue
        }
        return UIFontTextStyle.body.rawValue
    }
}
