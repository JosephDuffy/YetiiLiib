//
//  AboutViewController.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import QuartzCore

final class AboutViewController: UITableViewController {
    typealias TwitterApplication = (title: String, url: URL)

    private var headerView: UIView!

    public var primaryPeople: [AboutScreenUser] = [
        AboutScreenUser(displayName: "Yetii Ltd.", title: "Company News", twitterUsername: "YetiiNet"),
        AboutScreenUser(displayName: "Joseph Duffy", title: "Developer", twitterUsername: "Joe_Duffy")
    ]

    public var specialThanksPeople: [AboutScreenUser] = []

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

    public init(applicationUser: AboutScreenUser, specialThanksPeople: [AboutScreenUser]) {
        super.init(style: .grouped)

        self.primaryPeople.insert(applicationUser, at: 0)
        self.specialThanksPeople = specialThanksPeople
    }

    // Required for iOS 7
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        if let currentTableHeaderView = self.tableView.tableHeaderView {
            currentTableHeaderView.removeFromSuperview()
        }
        // Setting the table header view with a height of 0.01 fixes a bug that adds a gap between the
        // tableHeaderView (once added) and the top row. See: http://stackoverflow.com/a/18938763/657676
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0.01))
        self.headerView = AboutTableViewHeaderView(frame: CGRect.zero)

        self.title = "About"

        // Uncomment this line to hide the top line of the table view
        //        self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        self.tableView.alwaysBounceVertical = false
        self.tableView.register(TwitterUserTableViewCell.self, forCellReuseIdentifier: TwitterUserTableViewCell.reuseIdentifier())
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier())
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.specialThanksPeople.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.primaryPeople.count
        } else if section == 1 {
            return self.specialThanksPeople.count
        } else {
             return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect.zero)
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Special Thanks"
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row

        if section == 0 || section == 1 {
            let person: AboutScreenUser

            if section == 0 {
                person = self.primaryPeople[row]
            } else {
                person = self.specialThanksPeople[row]
            }

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

        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let person = person(for: indexPath) else { return }
        guard let username = person.twitterUsername else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let alertController = UIAlertController(title: username, message: "Choose how to view @\(username)'s profile", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.popoverPresentationController?.sourceRect = cell.bounds

        for application in self.actionSheetTwitterApplications {
            let action = UIAlertAction(title: application.title, style: .default, handler: { action in
                var url = application.url
                url.appendPathComponent(username)

                UIApplication.shared.openURL(url)
            })

            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    private func person(for indexPath: IndexPath) -> AboutScreenUser? {
        let section = indexPath.section
        let row = indexPath.row

        if section == 0 && row < primaryPeople.count {
            return primaryPeople[row]
        } else if section == 1 && row < specialThanksPeople.count {
            return specialThanksPeople[row]
        } else {
            return nil
        }
    }
    
}
