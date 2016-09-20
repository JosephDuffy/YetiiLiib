//
//  UILabel+Extensions.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(fontStyle: String) {
        self.init(frame: CGRect.zero)

        self.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: fontStyle))
    }

    func currentFontStyle() -> String {
        if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)) {
            return UIFontTextStyle.body.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)) {
            return UIFontTextStyle.headline.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)) {
            return UIFontTextStyle.caption1.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)) {
            return UIFontTextStyle.caption2.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)) {
            return UIFontTextStyle.footnote.rawValue
        } else if self.font.isEqual(UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)) {
            return UIFontTextStyle.subheadline.rawValue
        }
        return UIFontTextStyle.body.rawValue
    }
}
