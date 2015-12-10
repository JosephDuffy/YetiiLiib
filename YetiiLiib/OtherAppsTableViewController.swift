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

    /**
     The id of the developer to get the app information for. If `nil` no app information
     will be downloaded, but the `appMetaDatas` propertly will still be used
     To find your developer id visit: https://itunes.apple.com/search?term=yetii%20ltd&entity=software
     but replace "yetii%20ltd" with your own developer name and look for the "artistId" property.
     Examples:
      - Yetii Ltd.: 929726747
      - Apple: 284417353
    */
    public var developerId: Int?

    /**
     The campaign provider id (pt) to append to the app store URL. See
     https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns for
     more information.
    */
    public var campaignProviderId: Int?

    /**
     The campaign token (ct) to append to the app store URL. See
     https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns for
     more information.
     */
    public var campaignToken: String?

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "More Apps"

        self.tableView.estimatedRowHeight = 43.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "AppInformationTableViewCell", bundle: Utilities.framworkBundle), forCellReuseIdentifier: "AppInformationCell")

        if let developerId = self.developerId {
            // Get the current device's country code to ensure the correct currency is displayed for prices
            let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String ?? "us"

            Alamofire.request(.GET, "https://itunes.apple.com/lookup", parameters: [
                "id": developerId,
                "entity": "software",
                "country": countryCode
                ])
                .responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        if let JSON = JSON as? [String : AnyObject] {
                            if let resultsCount = JSON["resultCount"] as? Int, results = JSON["results"] as? [[String : AnyObject]] {
                                if resultsCount > 0 && self.companyName == nil {
                                    self.companyName = results[0]["artistName"] as? String
                                }

                                if resultsCount > 1 {
                                    for i in 1..<resultsCount {
                                        let appInformation = results[i]

                                        guard let appMetaData = AppMetaData(rawInformation: appInformation) else { break }

                                        // Don't include the current app
                                        guard appMetaData.bundleId != Utilities.getAppBundleId() else { break }

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
        let cell = tableView.dequeueReusableCellWithIdentifier("AppInformationCell", forIndexPath: indexPath) as! AppInformationTableViewCell

        if cell.appMetaData == nil {
            cell.appMetaData = self.appMetaDatas[indexPath.row]
        }

        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appMetaData = self.appMetaDatas[indexPath.row]

        var url = "itms-apps://itunes.apple.com/app/id\(appMetaData.appId)&mt=8"

        if let campaignProviderId = self.campaignProviderId {
            url += "&pt=\(campaignProviderId)"
        }

        if let campaignToken = self.campaignToken {
            url += "&ct=\(campaignToken)"
        }

        if let url = NSURL(string: url) {
            UIApplication.sharedApplication().openURL(url)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
