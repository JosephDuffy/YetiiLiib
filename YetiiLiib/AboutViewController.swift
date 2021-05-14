import UIKit
import QuartzCore
import SafariServices

@available(iOS 9.0, *)
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

    public let sections: [Section]

    public let otherAppsTableViewController: OtherAppsTableViewController?

    private let tableHeaderView = AboutTableViewHeaderView(frame: .zero)

    public init(sections: [Section], otherAppsTableViewController: OtherAppsTableViewController?) {
        self.sections = sections
        self.otherAppsTableViewController = otherAppsTableViewController

        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let currentTableHeaderView = tableView.tableHeaderView {
            currentTableHeaderView.removeFromSuperview()
        }
        
        // Setting the table header view with a height of 0.01 fixes a bug that adds a gap between the
        // tableHeaderView (once added) and the top row. See: http://stackoverflow.com/a/18938763/657676
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.01))

        title = "About"

        // Uncomment this line to hide the top line of the table view
        // self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = 56
        tableView.register(TwitterUserTableViewCell.self, forCellReuseIdentifier: TwitterUserTableViewCell.reuseIdentifier())
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier())
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier())
        tableView.delegate = self
        tableView.dataSource = self
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var frame = tableView.frame
        frame.size.height = tableHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        if tableView.tableHeaderView == nil || !frame.equalTo(tableHeaderView.frame) {
            tableHeaderView.frame = frame

            tableHeaderView.setNeedsLayout()
            tableHeaderView.layoutIfNeeded()

            tableView.tableHeaderView = tableHeaderView
        }
    }

    func actionSheetTwitterApplications() -> [TwitterApplication] {
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
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count + (otherAppsTableViewController != nil ? 1 : 0)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.indices.contains(section) {
            return sections[section].people.count
        } else {
            return 1
        }
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.indices.contains(section) else { return nil }

        return sections[section].title
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.indices.contains(indexPath.section) {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier(), for: indexPath)
            cell.textLabel?.text = "View more apps I've made"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if sections.indices.contains(indexPath.section) {
            let person = self.person(for: indexPath)

            guard let username = person.twitterUsername else { return }
            guard let cell = tableView.cellForRow(at: indexPath) else { return }

            let alertController = UIAlertController(title: username, message: "Choose how to view @\(username)'s profile", preferredStyle: .actionSheet)
            alertController.popoverPresentationController?.sourceView = cell
            alertController.popoverPresentationController?.sourceRect = cell.bounds

            for application in actionSheetTwitterApplications() {
                let action = UIAlertAction(title: application.title, style: .default, handler: { [weak self] action in
                    guard let `self` = self else { return }

                    var url = application.url
                    url.appendPathComponent(username)

                    if url.scheme == "http" || url.scheme == "https" {
                        let viewController = SFSafariViewController(url: url)
                        self.present(viewController, animated: true, completion: nil)
                    } else {
                        UIApplication.shared.open(url)
                    }
                })

                alertController.addAction(action)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        } else if let otherAppsTableViewController = otherAppsTableViewController {
            navigationController?.pushViewController(otherAppsTableViewController, animated: true)
        }
    }

    private func person(for indexPath: IndexPath) -> AboutScreenUser {
        let section = indexPath.section
        let row = indexPath.row

        return sections[section].people[row]
    }
    
}
