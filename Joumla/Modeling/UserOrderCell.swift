//
//  UserOrderCell.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
class userOrderCell : UITableViewCell{
    @IBOutlet var orderNumber : UILabel!
    @IBOutlet var salary : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet var process : UILabel!
    @IBOutlet var processIcon : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
