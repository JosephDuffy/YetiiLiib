import UIKit

final class UserLinkTableViewCell: SubtitleAndRightDetailTableViewCell, UIActionSheetDelegate {
    override class func reuseIdentifier() -> String {
        return "UserLinkTableViewCell"
    }

    func displayUser(_ user: AboutScreenUser) {
        textLabel?.text = user.displayName
        detailTextLabel?.text = user.title

        guard let link = user.link else {
            assertionFailure("User link should not be nil")
            return
        }

        rightDetailLabel.text = link.title
    }
}
