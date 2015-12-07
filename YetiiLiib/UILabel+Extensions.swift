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

        self.font = UIFont.preferredFontForTextStyle(fontStyle)
    }

    func currentFontStyle() -> String {
        if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleBody)) {
            return UIFontTextStyleBody
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)) {
            return UIFontTextStyleHeadline
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)) {
            return UIFontTextStyleCaption1
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)) {
            return UIFontTextStyleCaption2
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)) {
            return UIFontTextStyleFootnote
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)) {
            return UIFontTextStyleSubheadline
        }
        return UIFontTextStyleBody
    }
}