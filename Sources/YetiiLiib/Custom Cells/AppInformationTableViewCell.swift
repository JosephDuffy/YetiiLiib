import UIKit

public final class AppInformationTableViewCell: UITableViewCell {

    public class func reuseIdentifier() -> String {
        return "AppInformationTableViewCell"
    }

    @IBOutlet private var appIconImageView: UIImageView! {
        didSet {
            appIconImageView.accessibilityIgnoresInvertColors = true
        }
    }
    @IBOutlet private var appIconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var appNameLabel: UILabel!
    @IBOutlet private var appPriceLabel: UILabel!

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

    public var appMetaData: AppMetaData? {
        didSet {
            if let appMetaData = self.appMetaData {
                self.setup(for: appMetaData)
            }
        }
    }

    private func setup(for appMetaData: AppMetaData) {
        appNameLabel.text = appMetaData.name
        self.appPriceLabel.text = appMetaData.formattedPrice

        if let imageView = self.imageView , imageView.image == nil {
            self.appIconActivityIndicator.startAnimating()

            Task {
                let image = appMetaData.imageForSize(imageView.frame.size, scale: UIScreen.main.scale)
                imageView.image = image
                self.appIconActivityIndicator.stopAnimating()
                // Cause the image to actually be shown
                self.setNeedsLayout()
            }
        }
    }
    
}
