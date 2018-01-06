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
        rightDetailLabel = UILabel()

        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(rightDetailLabel)

        let topConstraint = NSLayoutConstraint(item: rightDetailLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 18)
        let bottomConstraint = NSLayoutConstraint(item: rightDetailLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 18)
        topConstraint.priority = .defaultHigh
        bottomConstraint.priority = .defaultHigh

        contentView.addConstraints([
            NSLayoutConstraint(item: rightDetailLabel, attribute: .trailingMargin, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: rightDetailLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightDetailLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: textLabel, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: rightDetailLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: detailTextLabel, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: rightDetailLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: contentView, attribute: .top, multiplier: 1, constant: 18),
            NSLayoutConstraint(item: rightDetailLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 18),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

