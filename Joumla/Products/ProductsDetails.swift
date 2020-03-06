//
//  ProductsDetails.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/23/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import PopupDialog
class ProductsDetails: common{

    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var topView : UIView!
    @IBOutlet var OrderNumber : UILabel!
    @IBOutlet var View1 : UIView!
    @IBOutlet var image : UIImageView!
    var OrderNumberHasAdded = 1
    @IBAction func back(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddOrder(sender : UIButton){
        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            showCustomDialog()
        }else{
            if sender.imageView?.image == #imageLiteral(resourceName: "ic_cart") {
                sender.setImage(#imageLiteral(resourceName: "ic_cart_white"), for: .normal)
                sender.backgroundColor = UIColor(named: "green")
                sender.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @IBAction func Plus(sender : UIButton){
        OrderNumberHasAdded += 1
        OrderNumber.text = "\(OrderNumberHasAdded)"
    }
    @IBAction func Minus(sender : UIButton){
        OrderNumberHasAdded -= 1
        OrderNumberHasAdded = max(OrderNumberHasAdded, 1)
        OrderNumber.text = "\(OrderNumberHasAdded)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners(cornerRadius: 10)
    }
    func roundCorners(cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: View1.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = View1.bounds
        maskLayer.path = path.cgPath
        image.layer.mask = maskLayer
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y / 3)) * -1)
    }
  
   
}
