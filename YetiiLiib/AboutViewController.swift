//
//  AboutViewController.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import QuartzCore
import SafariServices

final public class AboutViewController: UITableViewController {

    public struct Section {
        public let title: String?

        public let people: [AboutScreenUser]

        public init(title: String?, people: [AboutScreenUser]) {
            self.title = title
            self.people = people
        }
    }

    typealias TwitterApplication = (title: String, url: URL)

    private var headerView: UIView!

    public let sections: [Section]

    lazy var actionSheetTwitterApplications: [TwitterApplication] = {
        var actionSheetTwitterApplications = [TwitterApplication]()

        let sharedApplication = UIApplication.shared
        if sharedApplication.canOpenURL(URL(string: "tweetbot://")!), let url = URL(string: "tweetbot:///user_profile/") {
            // Tweetbot is installed
            actionSheetTwitterApplications.append(TwitterApplication("Tweetbot", url))
        }

        if sharedApplication.canOpenURL(URL(string: "twitterrific://")!), let url = URL(string: "twitterrific:///profile?screen_name=") {
            // Twitterrific is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitterrific", url))
        }

        if sharedApplication.canOpenURL(URL(string: "twitter://")!), let url = URL(string: "twitter://user?screen_name=") {
            // Twitter is installed
            actionSheetTwitterApplications.append(TwitterApplication("Twitter", url))
        }

        if sharedApplication.canOpenURL(URL(string: "googlechromes://")!), let url = URL(string: "googlechromes://www.twitter.com/") {
            // Google Chrome is installed
            actionSheetTwitterApplications.append(TwitterApplication("Google Chrome", url))
        }

        let safariURL = URL(string: "https://www.twitter.com/")!
        actionSheetTwitterApplications.append(TwitterApplication("Safari", safariURL))

        return actionSheetTwitterApplications
    }()

    public init(sections: [Section]) {
        self.sections = sections

        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let currentTableHeaderView = self.tableView.tableHeaderView {
            currentTableHeaderView.removeFromSuperview()
        }
        // Setting the table header view with a height of 0.01 fixes a bug that adds a gap between the
        // tableHeaderView (once added) and the top row. See: http://stackoverflow.com/a/18938763/657676
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0.01))
        headerView = AboutTableViewHeaderView(frame: CGRect.zero)

        title = "About"

        // Uncomment this line to hide the top line of the table view
        //        self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        tableView.alwaysBounceVertical = false
        tableView.register(TwitterUserTableViewCell.self, forCellReuseIdentifier: TwitterUserTableViewCell.reuseIdentifier())
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier())
        tableView.delegate = self
        tableView.dataSource = self
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let tableHeaderView = self.headerView {
            var frame = self.tableView.frame
            frame.size.height = tableHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            if self.tableView.tableHeaderView == nil || !frame.equalTo(tableHeaderView.frame) {
                tableHeaderView.frame = frame

                tableHeaderView.setNeedsLayout()
                tableHeaderView.layoutIfNeeded()

                self.tableView.tableHeaderView = tableHeaderView
            }
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].people.count
    }

    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }

        return UITableViewAutomaticDimension
    }

    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: .zero)
        }

        return nil
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = self.person(for: indexPath)

        if person.twitterUsername != nil {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: TwitterUserTableViewCell.reuseIdentifier(), for: indexPath) as! TwitterUserTableViewCell
            cell.user = person
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.reuseIdentifier(), for: indexPath)
            cell.textLabel?.text = person.displayName
            cell.detailTextLabel?.text = person.title
            cell.selectionStyle = .none
            return cell
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let person = self.person(for: indexPath)

        guard let username = person.twitterUsername else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let alertController = UIAlertController(title: username, message: "Choose how to view @\(username)'s profile", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.popoverPresentationController?.sourceRect = cell.bounds

        for application in self.actionSheetTwitterApplications {
            let action = UIAlertAction(title: application.title, style: .default, handler: { [weak self] action in
                var url = application.url
                url.appendPathComponent(username)

                if #available(iOS 9.0, *), let `self` = self, url.scheme == "http" || url.scheme == "https" {
                    let viewController = SFSafariViewController(url: url)
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            })

            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    private func person(for indexPath: IndexPath) -> AboutScreenUser {
        let section = indexPath.section
        let row = indexPath.row

        return sections[section].people[row]
    }
    
}
