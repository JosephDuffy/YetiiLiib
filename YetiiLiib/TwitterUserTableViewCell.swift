import UIKit

private typealias TwitterApplication = (title: String, url: URL)

final class TwitterUserTableViewCell: SubtitleAndRightDetailTableViewCell, UIActionSheetDelegate {
    override class func reuseIdentifier() -> String {
        return "TwitterUserTableViewCell"
    }

    fileprivate lazy var actionSheetTwitterApplications: [TwitterApplication] = {
        var actionSheetTwitterApplications = [TwitterApplication]()

        let sharedApplication = UIApplication.shared
        if sharedApplication.canOpenURL(URL(string: "tweetbot://")!), let url = URL(string: "tweetbot:///user_profile/\(self.username)") {
            // Tweetbot is installed
            actionSheetTwitterApplications.append(TwitterApplication("Tweetbot", url))
        }

        if sharedApplication.canOpenURL(URL(string: "twitterrific://")!), let url = URL(string: "twitterrific:///profile?screen_name=\(self.username)") {
            // Twitterrific is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitterrific", url))
        }

        if sharedApplication.canOpenURL(URL(string: "twitter://")!), let url = URL(string: "twitter://user?screen_name=\(self.username)") {
            // Twitter is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitter", url))
        }

        if sharedApplication.canOpenURL(URL(string: "googlechromes://")!), let url = URL(string: "googlechromes://www.twitter.com/\(self.username)") {
            // Google Chrome is installed
            actionSheetTwitterApplications.append(TwitterApplication("Google Chrome", url))
        }

        let safariURL = URL(string: "https://www.twitter.com/\(self.username)")!
        actionSheetTwitterApplications.append(TwitterApplication("Safari", safariURL))

        return actionSheetTwitterApplications
    }()

    fileprivate lazy var alertController: UIAlertController = {
        let controller = UIAlertController(title: self.username, message: "Choose how to view @\(self.username)'s profile", preferredStyle: .actionSheet)
        controller.popoverPresentationController?.sourceView = self
        controller.popoverPresentationController?.sourceRect = self.bounds

        for application in self.actionSheetTwitterApplications {
            let action = UIAlertAction(title: application.title, style: .default, handler: { (action) -> Void in
                UIApplication.shared.openURL(application.url)
            })

            controller.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)

        return controller
    }()

    open var user: AboutScreenUser! {
        didSet {
            assert(user.twitterUsername != nil)
            
            self.textLabel?.text = self.user.displayName
            self.detailTextLabel?.text = self.user.title
            self.rightDetailLabel.text = "@\(self.username)"
        }
    }

    open var username: String {
        return self.user.twitterUsername!
    }
    
}
