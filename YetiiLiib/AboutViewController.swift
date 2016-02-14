//
//  AboutViewController.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import QuartzCore

public class AboutViewController: UITableViewController {

    var actionSheetButtonURLs: [Int : NSURL]!
    var headerView: UIView!

    public var primaryPeople: [AboutScreenUser] = [
        AboutScreenUser(displayName: "Yetii Ltd.", title: "Company News", twitterUsername: "YetiiNet"),
        AboutScreenUser(displayName: "Joseph Duffy", title: "Developer", twitterUsername: "Joe_Duffy")
    ]

    public var specialThanksPeople: [AboutScreenUser] = [

    ]

    public init(applicationUser: AboutScreenUser, specialThanksPeople: [AboutScreenUser]) {
        super.init(style: .Grouped)

        self.primaryPeople.insert(applicationUser, atIndex: 0)
        self.specialThanksPeople = specialThanksPeople
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
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0.01))
        self.headerView = AboutTableViewHeaderView(frame: CGRectZero)

        self.title = "About"

        // Uncomment this line to hide the top line of the table view
        //        self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        self.tableView.alwaysBounceVertical = false
        self.tableView.registerClass(TwitterUserTableViewCell.self, forCellReuseIdentifier: TwitterUserTableViewCell.reuseIdentifier())
        self.tableView.registerClass(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier())
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let tableHeaderView = self.headerView {
            var frame = CGRectZero
            frame.size.width = self.tableView.bounds.size.width
            frame.size.height = tableHeaderView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            if self.tableView.tableHeaderView == nil || !CGRectEqualToRect(frame, tableHeaderView.frame) {
                tableHeaderView.frame = frame

                tableHeaderView.setNeedsLayout()
                tableHeaderView.layoutIfNeeded()

                self.tableView.tableHeaderView = tableHeaderView
            }
        }
    }

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.primaryPeople.count
        } else if section == 1 {
            return self.specialThanksPeople.count
        }
        fatalError("Cannot get a number of rows for a section that doesn't exist")
    }

    public override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableViewAutomaticDimension
    }

    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRectZero)
        }
        return nil
    }

    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Special Thanks"
        }
        return nil
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row

        if section == 0 || section == 1 {
            let person: AboutScreenUser

            if section == 0 {
                person = self.primaryPeople[row]
            } else {
                person = self.specialThanksPeople[row]
            }

            if person.twitterUsername != nil {
                let cell = self.tableView.dequeueReusableCellWithIdentifier(TwitterUserTableViewCell.reuseIdentifier(), forIndexPath: indexPath) as! TwitterUserTableViewCell
                cell.user = person
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCellWithIdentifier(SubtitleTableViewCell.reuseIdentifier(), forIndexPath: indexPath)
                cell.textLabel?.text = person.displayName
                cell.detailTextLabel?.text = person.title
                cell.selectionStyle = .None
                return cell
            }
        }

        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let twitterCell = self.tableView.cellForRowAtIndexPath(indexPath) as? TwitterUserTableViewCell {
            if #available(iOS 8.0, *) {
                let alertController = twitterCell.alertController
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let actionSheet = twitterCell.actionSheet
                actionSheet.showInView(self.view)
            }
        }
    }
    
}
