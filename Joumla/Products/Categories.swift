//
//  Categories.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class Categories: common {

    var Flip = false
    var CategoriesArr = [CategoriesDetails]()
    @IBOutlet var collectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        getOrdersData(url: "https://services-apps.net/jaddastore/public/api/categories")
    }
    
    
    func getOrdersData(url: String){
        loading()
        let headers = [
             "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(CategoriesData.self, from: jsonData)
                if error == nil{
                    if success{
                        self.CategoriesArr = dataRecived.data
                        self.collectionView.reloadData()
                        self.stopAnimating()
                    }
                    else  {
                        let alert = UIAlertController(title: "Alert", message: dataRecived.message , preferredStyle: UIAlertController.Style.alert)
                        self.stopAnimating()
                        self.present(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            @unknown default:
                                print("default")
                            }}))
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                }
            } catch {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Alert", message: "حدث خطأ بالرجاء التاكد من تسجيل الدخول " , preferredStyle: UIAlertController.Style.alert)
                self.stopAnimating()
                self.present(alert, animated: true, completion: nil)
                self.showCustomDialog()
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        print("default")
                    }}))
            }
        }
        
    }
    
    
    
}
extension Categories : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.CategoriesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as! CategoriesCell
        cell.name.text = self.CategoriesArr[indexPath.row].name
        cell.productsList.text = "\(self.CategoriesArr[indexPath.row].productsList)"
        cell.imagePath.sd_setImage(with: URL(string: self.CategoriesArr[indexPath.row].imagePath ?? ""))
        if self.CategoriesArr[indexPath.row].imagePath == nil{
            cell.imagePath.image = #imageLiteral(resourceName: "7-Nuts")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "ProductList", sender: self.CategoriesArr[indexPath.row].id)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductList" {
            if let destination = segue.destination as? UINavigationController{
                if let dest = destination.viewControllers[0] as? Products{
                    dest.CategoryId = sender as? Int
                }
            }
        }
    }
}
extension Categories: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
                if Flip{
                    if indexPath.row % 2 == 0{
                          return CGFloat(240)
                    }else{
                         Flip = false
                          return CGFloat(300)
                    }
                }else{
                    if indexPath.row % 2 == 1{
                          Flip = true
                         return CGFloat(240)
                    }else{
        
                          return CGFloat(300)
                    }
             }
        }
}
