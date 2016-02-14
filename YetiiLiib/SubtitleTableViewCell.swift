//
//  SubtitleTableViewCell.swift
//  YetiiLiib
//
//  Created by Joseph Duffy on 07/12/2015.
//  Copyright © 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    class func reuseIdentifier() -> String {
        return "SubtitleTableViewCell"
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
