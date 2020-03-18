//
//  Products.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/22/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class Products: common {

    var FilterIds = [Int]()
    var FilterArr = [FiltersData]()
    @IBOutlet var CollectionView : UICollectionView!
    @IBOutlet var FilterCollection : UICollectionView!
    @IBOutlet var CollectionHieght : NSLayoutConstraint!
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    @IBOutlet var topView : UIView!
    @IBOutlet var FilterView : UIView!
    @IBOutlet var OrderNumber : UILabel!
    @IBOutlet var ProductDetailsStackView : UIStackView!
    
    @IBOutlet var CategoryName : UILabel!
    @IBOutlet var CategoryImage : UIImageView!
    
    var OrderNumberHasAdded = 1
    var PageNumber = 1
    var CategoryId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateConstraints()
       getOrdersData(methodType: "GET", url: "https://services-apps.net/jaddastore/public/api/sub-categories/\(CategoryId ?? 0)")
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
            self.FilterIds.append(sender.tag)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_chcek"), for: .normal)
            for (idx,x) in FilterIds.enumerated(){
                if x == sender.tag{
                    FilterIds.remove(at: idx)
                    break
                }
            }
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

    func getOrdersData(methodType: String,url: String){
        loading()
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        var infoo : [String: Any]?
        if methodType == "POST"{
            let x = SendSubData(category_id: CategoryId ?? 0, subcategories_ids: [])
            let data = try! JSONEncoder.init().encode(x)
                let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
                infoo = dictionary
        }
        AlamofireRequests.PostMethod(methodType: methodType, url: url, info: infoo ?? [:], headers: headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(Filters.self, from: jsonData)
                    if success{
                        self.FilterArr = dataRecived.data
                        self.FilterCollection.reloadData()
                        for (indx,x) in self.FilterArr.enumerated(){
                             self.FilterIds.append(x.id)
                            if indx+1 == self.FilterArr.count{
                                self.getProducts(url: "https://services-apps.net/jaddastore/public/api/products")
                            }
                        }
                        
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
                let alert = UIAlertController(title: "Alert", message: "حدث خطأ بالرجاء التاكد من اتصالك بالانترنت " , preferredStyle: UIAlertController.Style.alert)
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
    
    func getProducts(url: String){
        loading()
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
      
        let x = SendSubData(category_id: CategoryId ?? 0, subcategories_ids: self.FilterIds)
        let data = try! JSONEncoder.init().encode(x)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: dictionary , headers: headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(PostProducts.self, from: jsonData)
                    if success{
                        self.CategoryName.text = dataRecived.data?.main_category?.name ?? ""
                        self.CategoryImage.sd_setImage(with: URL(string: dataRecived.data?.main_category?.imagePath ?? ""))
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
                let alert = UIAlertController(title: "Alert", message: "حدث خطأ بالرجاء التاكد من اتصالك بالانترنت " , preferredStyle: UIAlertController.Style.alert)
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
extension Products : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == FilterCollection{
             return self.FilterArr.count
        }else{
              return 6
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView == FilterCollection{
            return CGSize(width: (collectionView.frame.width-10)/2, height: 40)
        }else{
             return CGSize(width: (collectionView.frame.width-20)/2, height: 300)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == FilterCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Filter", for: indexPath) as! FilterCell
            cell.name.setTitle("  \(self.FilterArr[indexPath.row].name ?? "")", for: .normal)
            cell.name.setImage(#imageLiteral(resourceName: "ic_chcek_active"), for: .normal)
            cell.name.tag = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == FilterCollection{
            
        }else{
            PageNumber = 2
            hidesPages()
        }
    }
}


struct SendSubData:Codable{
     init(category_id: Int?, subcategories_ids: [Int]?) {
        self.category_id = category_id
        self.subcategories_ids = subcategories_ids
    }
    
    var category_id: Int?
    var subcategories_ids: [Int]?
    
}
