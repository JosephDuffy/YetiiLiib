//
//  AboutTableViewHeaderView.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class AboutTableViewHeaderView: UIView {
    let imageView = UIImageView()
    let appNameLabel = UILabel(fontStyle: UIFontTextStyleHeadline)
    let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let appName = Utilities.getAppName()
        let appVersion = Utilities.getAppVersion()
        let appBuild = Utilities.getAppBuild()

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = Utilities.getAboutScreenAppIconImage() {
            if let imageMask = UIImage(named: "iOS 7 Icon Mask", inBundle: Utilities.framworkBundle, compatibleWithTraitCollection: nil) {
                self.imageView.image = image.imageAfterApplyingMask(imageMask)
            } else {
                print("Failed to get icon mask from bundle: \(Utilities.framworkBundle)")
            }
        } else {
            print("Failed to get app icon image")
        }

        self.appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.appNameLabel.textAlignment = .Center
        self.appNameLabel.text = "\(appName) \(appVersion) (build \(appBuild))"
        self.appNameLabel.sizeToFit()

        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.text = "\(appName) is lovingly created by Yetii Ltd., and wouldn't be possible without these awesome people."
        self.updateDescriptionLabelPMLW()

        self.addSubview(self.imageView)
        self.addSubview(self.appNameLabel)
        self.addSubview(self.descriptionLabel)

        self.addConstraints([
            // App icon constraints
            NSLayoutConstraint(item: self.imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 128),
            NSLayoutConstraint(item: self.imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 128),

            // App name label constraints
            NSLayoutConstraint(item: self.appNameLabel, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: -16),

            // Description label constrains
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .Top, relatedBy: .Equal, toItem: self.appNameLabel, attribute: .Bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.descriptionLabel, attribute: .Bottom, multiplier: 1, constant: 8)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        self.updateDescriptionLabelPMLW()

        super.layoutSubviews()
    }

    private func updateDescriptionLabelPMLW() {
        /*
        iOS 7
        Tested on:
        - iPad 2 (7.0.6)
        - iPhone 4 (7.1.1)

        iOS 8.1
        Tested on:
        - iPhone 5 (sim)
        - iPad Retina (sim)

        iOS 9
        Tested on:
        - iPhone 6
        - iPad Air 2
        */
        // -32 for the 16 padding on the left and right
        let newValue = self.frame.width - 32

        if self.descriptionLabel.preferredMaxLayoutWidth != newValue {
            self.descriptionLabel.preferredMaxLayoutWidth = newValue
            self.descriptionLabel.sizeToFit()

            // Check for iOS 9 devices in landscape
            // This should also check for iPads (specifically iPad Air 2), which fixes the issue
            // of the label being truncated ("...") when using the slide in feature
            if #available(iOS 9.0, *) {
                if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                    self.superview?.setNeedsLayout()
                    self.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
}
