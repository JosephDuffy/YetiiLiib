//
//  TwitterUserTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

private typealias TwitterApplication = (title: String, url: NSURL)

public class TwitterUserTableViewCell: SubtitleAndRightDetailTableViewCell, UIActionSheetDelegate {
    override class func reuseIdentifier() -> String {
        return "TwitterUserTableViewCell"
    }

    private lazy var actionSheetTwitterApplications: [TwitterApplication] = {
        var actionSheetTwitterApplications = [TwitterApplication]()

        let sharedApplication = UIApplication.sharedApplication()
        if sharedApplication.canOpenURL(NSURL(string: "tweetbot://")!), let url = NSURL(string: "tweetbot:///user_profile/\(self.username)") {
            // Tweetbot is installed
            actionSheetTwitterApplications.append(TwitterApplication("Tweetbot", url))
        }

        if sharedApplication.canOpenURL(NSURL(string: "twitterrific://")!), let url = NSURL(string: "twitterrific:///profile?screen_name=\(self.username)") {
            // Twitterrific is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitterrific", url))
        }

        if sharedApplication.canOpenURL(NSURL(string: "twitter://")!), let url = NSURL(string: "twitter://user?screen_name=\(self.username)") {
            // Twitter is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitter", url))
        }

        if sharedApplication.canOpenURL(NSURL(string: "googlechromes://")!), let url = NSURL(string: "googlechromes://www.twitter.com/\(self.username)") {
            // Google Chrome is installed
            actionSheetTwitterApplications.append(TwitterApplication("Google Chrome", url))
        }

        let safariURL = NSURL(string: "https://www.twitter.com/\(self.username)")!
        actionSheetTwitterApplications.append(TwitterApplication("Safari", safariURL))

        return actionSheetTwitterApplications
    }()

    @available(iOS, deprecated=8.0)
    public lazy var actionSheet: UIActionSheet = {
        let actionSheet = UIActionSheet(title: "Choose how to view @\(self.username)'s profile", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)

        for application in self.actionSheetTwitterApplications {
            actionSheet.addButtonWithTitle(application.title)
        }

        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1
        return actionSheet
    }()

    @available(iOS 8.0, *)
    public lazy var alertController: UIAlertController = {
        let controller = UIAlertController(title: self.username, message: "Choose how to view @\(self.username)'s profile", preferredStyle: .ActionSheet)
        controller.popoverPresentationController?.sourceView = self
        controller.popoverPresentationController?.sourceRect = self.bounds

        for application in self.actionSheetTwitterApplications {
            let action = UIAlertAction(title: application.title, style: .Default, handler: { (action) -> Void in
                UIApplication.sharedApplication().openURL(application.url)
            })

            controller.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        controller.addAction(cancelAction)

        return controller
    }()

    public var user: AboutScreenUser! {
        didSet {
            assert(user.twitterUsername != nil)
            
            self.textLabel?.text = self.user.displayName
            self.detailTextLabel?.text = self.user.title
            self.rightDetailLabel.text = "@\(self.username)"
        }
    }

    public var username: String {
        return self.user.twitterUsername!
    }

    @available(iOS, obsoleted=8.0)
    public func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        guard buttonIndex != actionSheet.cancelButtonIndex else { return }

        let application = self.actionSheetTwitterApplications[buttonIndex]
        UIApplication.sharedApplication().openURL(application.url)
    }
    
}
