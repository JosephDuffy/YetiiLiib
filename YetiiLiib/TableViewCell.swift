import UIKit

public class TableViewCell: UITableViewCell {

    public class func reuseIdentifier() -> String {
        return "TableViewCell"
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
