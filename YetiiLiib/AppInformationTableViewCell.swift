//
//  AppInformationTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 09/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public class AppInformationTableViewCell: UITableViewCell {
    class func reuseIdentifier() -> String {
        return "AppInformationTableViewCell"
    }

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appIconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appPriceLabel: UILabel!

    public override var textLabel: UILabel? {
        get {
            return self.appNameLabel
        }
    }

    public override var detailTextLabel: UILabel? {
        get {
            return self.appPriceLabel
        }
    }

    public override var imageView: UIImageView? {
        get {
            return self.appIconImageView
        }
    }

    public internal(set) var appMetaData: AppMetaData? {
        didSet {
            if let appMetaData = self.appMetaData {
                self.setupForAppMetaData(appMetaData)
            }
        }
    }

    private func setupForAppMetaData(appMetaData: AppMetaData) {
        self.appNameLabel.text = appMetaData.name
        self.appPriceLabel.text = appMetaData.formattedPrice

        if let imageView = self.imageView where imageView.image == nil {
            self.appIconActivityIndicator.startAnimating()
            appMetaData.imageForSize(imageView.frame.size, callback: { (image) -> Void in
                imageView.image = image
                self.appIconActivityIndicator.stopAnimating()
                // Cause the image to actually be shown
                self.setNeedsLayout()
            })
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.appNameLabel.preferredMaxLayoutWidth = self.appNameLabel.frame.size.width
        self.appNameLabel.sizeToFit()
    }
    
}
