//
//  AboutTableViewHeaderView.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public final class AboutTableViewHeaderView: UIView {
    public let imageView = UIImageView()
    public let appNameLabel = UILabel(fontStyle: UIFontTextStyle.headline.rawValue)
    public let descriptionLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let appName = Bundle.main.appName
        let appVersion = Bundle.main.appVersion
        let appBuild = Bundle.main.appBuild

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "App Icon 128pt", in: Bundle.main, compatibleWith: nil) {
            self.imageView.image = image.imageAfterApplyingAppIconMask()
        } else {
            print("Failed to get app icon image")
        }

        self.appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.appNameLabel.textAlignment = .center
        self.appNameLabel.text = "\(appName) \(appVersion) (build \(appBuild))"
        self.appNameLabel.sizeToFit()

        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.text = "\(appName) is lovingly created by Yetii Ltd., and wouldn't be possible without these awesome people."
        self.updateDescriptionLabelPMLW()

        self.addSubview(self.imageView)
        self.addSubview(self.appNameLabel)
        self.addSubview(self.descriptionLabel)

        self.addConstraints([
            // App icon constraints
            NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 128),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 128),

            // App name label constraints
            NSLayoutConstraint(item: self.appNameLabel, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16),

            // Description label constrains
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .top, relatedBy: .equal, toItem: self.appNameLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: self.descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.descriptionLabel, attribute: .bottom, multiplier: 1, constant: 8)
            ])
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
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
                if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
                    self.superview?.setNeedsLayout()
                    self.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
}
