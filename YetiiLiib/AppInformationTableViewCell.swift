//
//  AppInformationTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 09/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public final class AppInformationTableViewCell: UITableViewCell {
    public class func reuseIdentifier() -> String {
        return "AppInformationTableViewCell"
    }

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appIconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appPriceLabel: UILabel!

    open override var textLabel: UILabel? {
        get {
            return self.appNameLabel
        }
    }

    open override var detailTextLabel: UILabel? {
        get {
            return self.appPriceLabel
        }
    }

    open override var imageView: UIImageView? {
        get {
            return self.appIconImageView
        }
    }

    public var appMetaData: AppMetaData? {
        didSet {
            if let appMetaData = self.appMetaData {
                self.setup(for: appMetaData)
            }
        }
    }

    fileprivate func setup(for appMetaData: AppMetaData) {
        self.appNameLabel.text = appMetaData.name
        self.appPriceLabel.text = appMetaData.formattedPrice

        if let imageView = self.imageView , imageView.image == nil {
            self.appIconActivityIndicator.startAnimating()
            appMetaData.imageForSize(imageView.frame.size, callback: { (image) -> Void in
                imageView.image = image
                self.appIconActivityIndicator.stopAnimating()
                // Cause the image to actually be shown
                self.setNeedsLayout()
            })
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.appNameLabel.preferredMaxLayoutWidth = self.appNameLabel.frame.size.width
        self.appNameLabel.sizeToFit()
    }
    
}
