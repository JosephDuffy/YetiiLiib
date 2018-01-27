import UIKit

public class SubtitleTableViewCell: UITableViewCell {
    public class func reuseIdentifier() -> String {
        return "SubtitleTableViewCell"
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
