//
//  Products.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/22/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Products: UIViewController {

    @IBOutlet var CollectionView : UICollectionView!
    @IBOutlet var CollectionHieght : NSLayoutConstraint!
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    @IBOutlet var topView : UIView!
    @IBOutlet var FilterView : UIView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateConstraints()
        // Do any additional setup after loading the view.
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y / 3)) * -1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateConstraints()
    }
    fileprivate func UpdateConstraints(){
        self.CollectionView.layoutIfNeeded()
        self.CollectionHieght.constant = self.CollectionView.contentSize.height
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetails" {
           if let destination = segue.destination as? ProductsDetails {
                
            }
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
        performSegue(withIdentifier: "productDetails", sender: self)
    }
}
