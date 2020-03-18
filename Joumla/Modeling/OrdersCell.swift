//
//  OrdersCell.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet var orderName : UILabel!
    @IBOutlet var bio : UILabel!
    @IBOutlet var cost : UILabel!
    @IBOutlet var inPackage : UILabel!
    @IBOutlet var quantity : UILabel!
    @IBOutlet var OrderImage : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
