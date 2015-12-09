//
//  OtherAppsTableViewController.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 08/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import Alamofire

public class OtherAppsTableViewController: UITableViewController {

    public var appMetaDatas: [AppMetaData] = []
    public private(set) var hasLoadedApps = false
    public private(set) var errorLoadingApps = false
    public var companyName: String?

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "More Apps"

        self.tableView.registerClass(RightDetailTableViewCell.self, forCellReuseIdentifier: "AppMetaDataCell")

        Alamofire.request(.GET, "https://itunes.apple.com/lookup?id=929726747&entity=software")
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let JSON = JSON as? [String : AnyObject] {
                        print("Loaded JSON")
                        if let resultsCount = JSON["resultCount"] as? Int, results = JSON["results"] as? [[String : AnyObject]] {
                            print("Got \(resultsCount) result(s)")
                            if resultsCount > 0 && self.companyName == nil {
                                self.companyName = results[0]["artistName"] as? String
                            }

                            if resultsCount > 1 {
                                for i in 1..<resultsCount {
                                    let appInformation = results[i]

                                    print(appInformation["trackId"])
                                    print(appInformation["trackName"])
                                    print(appInformation["formattedPrice"])
                                    print(appInformation["artworkUrl60"])

                                    guard let appMetaData = AppMetaData(rawInformation: appInformation) else { break }

                                    // Don't include the current app
                                    guard appMetaData.bundleId != Utilities.getAppBundleId() else { break }

                                    print(appMetaData)
                                    self.appMetaDatas.append(appMetaData)
                                }
                            }
                        }
                    } else {
                        print("Invalid JSON")
                    }

                    self.hasLoadedApps = true
                    self.errorLoadingApps = false
                    self.tableView.reloadData()
                case .Failure(let error):
                    print("Request failed with error: \(error)")

                    self.hasLoadedApps = true
                    self.errorLoadingApps = true
                    self.tableView.reloadData()
                }
        }
    }

    // MARK: - Table view data source

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.appMetaDatas.count > 0 {
            self.tableView.backgroundView = nil

            return 1
        } else {
            if self.tableView.backgroundView == nil {
                let backgroundView = UIView(frame: self.tableView.frame)
                let label = UILabel()
                if !self.hasLoadedApps {
                    label.text = "Loading App Information"
                } else if self.errorLoadingApps {
                    label.text = "Error Loading App Information"
                } else if let companyName = self.companyName {
                    label.text = "No Other Apps Found For \(companyName)"
                } else {
                    label.text = "No Other Apps Found"
                }
                label.textAlignment = .Center
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false

                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                if !self.hasLoadedApps {
                    activityIndicator.startAnimating()
                }
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false

                backgroundView.addSubview(label)
                backgroundView.addSubview(activityIndicator)

                backgroundView.addConstraints([
                    NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: backgroundView, attribute: .Leading, multiplier: 1, constant: 16),
                    NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: backgroundView, attribute: .Trailing, multiplier: 1, constant: -16),
                    NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterY, multiplier: 1, constant: -8),
                    NSLayoutConstraint(item: activityIndicator, attribute: .Top, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterY, multiplier: 1, constant: 8),
                    NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterX, multiplier: 1, constant: 0)
                    ])

                self.tableView.backgroundView = backgroundView
            }

            return 0
        }
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appMetaDatas.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppMetaDataCell", forIndexPath: indexPath)

        let appMetaData = self.appMetaDatas[indexPath.row]

        cell.textLabel?.text = appMetaData.name
        cell.detailTextLabel?.text = appMetaData.formattedPrice

        if let imageView = cell.imageView where imageView.image == nil {
            appMetaData.imageForSize(imageView.frame.size, callback: { (image) -> Void in
                imageView.image = image
                // Cause the image to actually be shown
                cell.setNeedsLayout()
            })
        }

        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appMetaData = self.appMetaDatas[indexPath.row]
        if let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(appMetaData.appId)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
