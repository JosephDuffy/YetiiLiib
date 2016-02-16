//
//  SubtitleAndRightDetailTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

public class SubtitleAndRightDetailTableViewCell: UITableViewCell {
    class func reuseIdentifier() -> String {
        return "SubtitleAndRightDetailTableViewCell"
    }

    private(set) var rightDetailLabel: UILabel!
    private var didUpdateConstraints = false

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)

        let rightDetailLabel = UILabel()
        self.rightDetailLabel = rightDetailLabel
        rightDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(rightDetailLabel)

        if #available(iOS 8.0, *) {
            self.contentView.addConstraint(
                NSLayoutConstraint(item: self.rightDetailLabel, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.contentView, attribute: .TrailingMargin, multiplier: 1, constant: -8)
            )
        } else {
            self.contentView.addConstraint(
                NSLayoutConstraint(item: self.rightDetailLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -8)
            )
        }

        self.contentView.addConstraint(
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        )

        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self.textLabel, attribute: .Trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.rightDetailLabel, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self.detailTextLabel, attribute: .Trailing, multiplier: 1, constant: 8)
            ])
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}