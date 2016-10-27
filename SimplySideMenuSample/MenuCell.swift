//
//  MenuCell.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    //セル内の部品を配置
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuCopy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
