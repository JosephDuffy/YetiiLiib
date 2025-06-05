import UIKit

@available(iOS 9.0, *)
public final class OtherAppsTableViewController: UITableViewController {

    public var appMetaDatas: [AppMetaData] = []
    public var companyName: String?

    public private(set) var hasLoadedApps = false
    public private(set) var errorLoadingApps = false

    /**
     The id of the developer to get the app information for. If `nil` no app information
     will be downloaded, but the `appMetaDatas` propertly will still be used
     To find your developer id visit: https://itunes.apple.com/search?term=yetii%20ltd&entity=software
     but replace "yetii%20ltd" with your own developer name and look for the "artistId" property.
     Examples:
      - Yetii Ltd.: 929726747
      - Apple: 284417353
    */
    public let developerId: Int

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
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? "us"
    }()

    public init(developerId: Int) {
        self.developerId = developerId

        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "More Apps"

        tableView.estimatedRowHeight = 59.5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "AppInformationTableViewCell", bundle: Bundle.framework), forCellReuseIdentifier: AppInformationTableViewCell.reuseIdentifier())

        Task {
            await loadApps()
        }
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
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
                label.textAlignment = .center
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false

                let activityIndicator = UIActivityIndicatorView(style: .medium)
                if !self.hasLoadedApps {
                    activityIndicator.startAnimating()
                }
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false

                backgroundView.addSubview(label)
                backgroundView.addSubview(activityIndicator)

                backgroundView.addConstraints([
                    NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 16),
                    NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: -16),
                    NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: -8),
                    NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 8),
                    NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
                    ])

                self.tableView.backgroundView = backgroundView
            }

            return 0
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appMetaDatas.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppInformationTableViewCell.reuseIdentifier(), for: indexPath) as! AppInformationTableViewCell

        if cell.appMetaData == nil {
            cell.appMetaData = self.appMetaDatas[(indexPath as NSIndexPath).row]
        }

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appMetaData = self.appMetaDatas[(indexPath as NSIndexPath).row]

        do {
            let url = try appMetaData.appStoreURL(campaignProviderId: self.campaignProviderId, campaignToken: self.campaignToken)
            UIApplication.shared.open(url)
        } catch let error as URLGenerationError {
            print(error)
        } catch {
            print("Unknown error generating application URL")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private nonisolated func loadApps() async {
        @MainActor
        func errorLoadingData() {
            self.hasLoadedApps = true
            self.errorLoadingApps = true

            self.tableView.reloadData()
        }

        let urlString = "https://itunes.apple.com/lookup?id=\(developerId)&entity=software&country=\(await countryCode)"
        guard let url = URL(string: urlString) else {
            print("Failed to create NSURL from string: \(urlString)")
            await errorLoadingData()
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load NSData from url: \(url)")
            await errorLoadingData()
            return
        }

        do {
            var appMetaDatas: [AppMetaData] = []
            var companyName: String?

            if let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] {
                if let results = JSON["results"] as? [[String : AnyObject]] {
                    if companyName == nil, let firstResult = results.first {
                        companyName = firstResult["artistName"] as? String
                    }

                    for appInformation in results {
                        guard let appMetaData = AppMetaData(rawInformation: appInformation) else { continue }

                        // Don't include the current app
                        guard appMetaData.bundleId != Bundle.main.bundleIdentifier else { continue }

                        appMetaDatas.append(appMetaData)
                    }
                }
            } else {
                print("Invalid JSON")
            }

            Task { @MainActor in
                self.hasLoadedApps = true
                self.errorLoadingApps = false
                self.companyName = companyName
                self.appMetaDatas = appMetaDatas

                self.tableView.reloadData()
            }
        } catch {
            print("Error decoding NSData to JSON: \(error)")
            await errorLoadingData()
        }
    }
}
