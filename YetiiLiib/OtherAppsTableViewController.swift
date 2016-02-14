//
//  OtherAppsTableViewController.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 08/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

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
     The campaign provider id (pt) to append to the app store URL
     
     - SeeAlso: [https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns](https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns)
    */
    public var campaignProviderId: Int?

    /**
     The campaign token (ct) to append to the app store URL
     - SeeAlso: [https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns](https://itunespartner.apple.com/en/apps/faq/App%20Analytics_Campaigns)
     */
    public var campaignToken: String?

    /**
     The country code to use when querying the App Store for the the app data. Using the
     device's country code ensures the correct currency and value is displayed for app prices.
     Defaults to "us" if the code cannot be loaded from NSLocale
     */
    public var countryCode: String = {
        return NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String ?? "us"
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "More Apps"

        self.tableView.estimatedRowHeight = 43.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "AppInformationTableViewCell", bundle: Utilities.assetsBundle), forCellReuseIdentifier: AppInformationTableViewCell.reuseIdentifier())

        if let developerId = self.developerId {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                func errorLoadingData() {
                    self.hasLoadedApps = true
                    self.errorLoadingApps = true

                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }

                let urlString = "https://itunes.apple.com/lookup?id=\(developerId)&entity=software&country=\(self.countryCode)"
                guard let url = NSURL(string: urlString) else {
                    print("Failed to create NSURL from string: \(urlString)")
                    errorLoadingData()
                    return
                }

                guard let data = NSData(contentsOfURL: url) else {
                    print("Failed to load NSData from url: \(url)")
                    errorLoadingData()
                    return
                }

                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    if let JSON = json as? [String : AnyObject] {
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
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding NSData to JSON: \(error)")
                    errorLoadingData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(AppInformationTableViewCell.reuseIdentifier(), forIndexPath: indexPath) as! AppInformationTableViewCell

        if cell.appMetaData == nil {
            cell.appMetaData = self.appMetaDatas[indexPath.row]
        }

        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appMetaData = self.appMetaDatas[indexPath.row]

        do {
            let url = try appMetaData.appStoreURL(campaignProviderId: self.campaignProviderId, campaignToken: self.campaignToken)
            UIApplication.sharedApplication().openURL(url)
        } catch let error as URLGenerationError {
            print(error)
        } catch {
            print("Unknown error generating application URL")
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
