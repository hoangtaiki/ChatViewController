//
//  SelectionStyleCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 8/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

class SelectionStyleCell: UITableViewCell {

    var chatBarStyleTitle: UILabel!
    var useImagePickerDefaultSwitch: UISwitch!
    var showConversationButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .white
    }
}
