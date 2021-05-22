import UIKit

public class RightDetailTableViewCell: UITableViewCell {
    public class func reuseIdentifier() -> String {
        return "RightDetailTableViewCell"
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
