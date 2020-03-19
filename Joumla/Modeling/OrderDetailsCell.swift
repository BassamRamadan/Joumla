//
//  OrderDetailsCell.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
      @IBOutlet var title: UILabel!
      @IBOutlet var netPrice: UILabel!
      @IBOutlet var price: UILabel!
      @IBOutlet var packagePrice: UILabel!
      @IBOutlet var InPackage: UILabel!
      @IBOutlet var ProductImage: UIImageView!
}
class FilterCell: UICollectionViewCell {
    @IBOutlet var name: UIButton!
}
class PricesCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var price: UILabel!
}
