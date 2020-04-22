//
//  LabelTableViewCell.swift
//  HiberLink
//
//  Created by Nathan FALLET on 23/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
