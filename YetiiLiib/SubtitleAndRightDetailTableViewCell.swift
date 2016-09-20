//
//  SubtitleAndRightDetailTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public class SubtitleAndRightDetailTableViewCell: UITableViewCell {
    public class func reuseIdentifier() -> String {
        return "SubtitleAndRightDetailTableViewCell"
    }

    public let rightDetailLabel: UILabel

    private var didUpdateConstraints = false

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.rightDetailLabel = UILabel()

        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(rightDetailLabel)

        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .trailingMargin, relatedBy: .equal, toItem: self.contentView, attribute: .trailingMargin, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.textLabel, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.detailTextLabel, attribute: .trailing, multiplier: 1, constant: 8)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
