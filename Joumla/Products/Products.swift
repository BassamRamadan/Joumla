//
//  Products.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/22/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Products: common {

    @IBOutlet var CollectionView : UICollectionView!
    @IBOutlet var CollectionHieght : NSLayoutConstraint!
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    @IBOutlet var topView : UIView!
    @IBOutlet var FilterView : UIView!
    @IBOutlet var OrderNumber : UILabel!
    @IBOutlet var ProductDetailsStackView : UIStackView!
    var OrderNumberHasAdded = 1
    var PageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidesBottomBarWhenPushed = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PageNumber = 1
        hidesPages()
        UpdateConstraints()
    }
    
    fileprivate func UpdateConstraints(){
        self.CollectionView.layoutIfNeeded()
        self.CollectionHieght.constant = self.CollectionView.contentSize.height
    }
    
    @IBAction func FilterOpen(sender : UIButton){
        FilterView.isHidden = false
    }
    
    @IBAction func FilterClose(sender : UIButton){
        FilterView.isHidden = true
    }
    
    
    @IBAction func FilterSelection(sender : UIButton){
        if sender.imageView?.image == #imageLiteral(resourceName: "ic_chcek") {
            sender.setImage(#imageLiteral(resourceName: "ic_chcek_active"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_chcek"), for: .normal)
        }
    }
    fileprivate func hidesPages(){
        if PageNumber == 1{
            CollectionView.isHidden = false
            ProductDetailsStackView.isHidden = true
        }else{
            CollectionView.isHidden = true
            ProductDetailsStackView.isHidden = false
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
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        BagroundImage.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y/2)+22) * -1)
    }
    @IBAction func back(sender : UIButton) {
        if PageNumber == 2{
            PageNumber = 1
            hidesPages()
        }else{
            self.navigationController?.dismiss(animated: true)
        }
    }
}
extension Products : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-20)/2, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        PageNumber = 2
        hidesPages()
    }
}
