//
//  Trashing.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class CartVC: common {

    @IBOutlet var totalCost : UILabel!
    @IBOutlet var tax : UILabel!
    @IBOutlet var shipping : UILabel!
    @IBOutlet var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButtonWithDismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       setupShippingData()
    }
    func setupShippingData(){
        totalCost.text = AppDelegate.CommonCartItems?.totalCost ?? "0"
        tax.text = AppDelegate.CommonCartItems?.tax ?? "0"
        shipping.text = AppDelegate.CommonCartItems?.shipping ?? "0"
    }
    @IBAction func DeletItem(_ sender: UIButton?) {
        let alert = UIAlertController(title: "Alert", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            self.AddOrderToServer(isDeleting: true, index: sender?.tag ?? 0, quantity: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func SaveItem(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! OrdersCell
        self.AddOrderToServer(isDeleting: false, index: sender.tag , quantity: cell.quantity.text)
    }
    @IBAction func Plus(sender : UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! OrdersCell
        cell.Save.isHidden = false
        var x = Int((cell.quantity.text)!)
        x = x! + 1
        cell.quantity.text = "\(x!)"
    }
    @IBAction func Minus(sender : UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! OrdersCell
        cell.Save.isHidden = false
        var x = Int((cell.quantity.text)!)
        x = x! - 1
        x = max(x!,1)
        cell.quantity.text = "\(x!)"
    }
    
    func AddOrderToServer(isDeleting: Bool,index: Int,quantity: String?){
        loading()
        var url = "https://services-apps.net/jaddastore/public/api/edit-cart-item"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(CashedData.getUserApiKey() ?? "")"
        ]
        var parameters : [String : Any] = [
            "cart_id": AppDelegate.CommonCartItems?.cartId ?? 0,
            "item_id": AppDelegate.CommonCartItems?.items[index].id ?? 0,
            "quantity": quantity ?? "0"
        ]
        if isDeleting{
            url = "https://services-apps.net/jaddastore/public/api/delete-cart-item"
            parameters = [
                "cart_id": AppDelegate.CommonCartItems?.cartId ?? 0,
                "item_id": AppDelegate.CommonCartItems?.items[index].id ?? 0
            ]
        }
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: parameters , headers: headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    if success{
                        AppDelegate.HasAddNewOrder = true
                        if isDeleting{
                            self.present(common.makeAlert(message: "تم الحذف بنجاح"), animated: true, completion: nil)
                        }
                        self.getCartItems(){
                            () in
                            self.setupShippingData()
                            self.tableView.reloadData()
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
}
extension CartVC : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.CommonCartItems?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trashing", for: indexPath) as! OrdersCell
        cell.orderName.text = AppDelegate.CommonCartItems?.items[indexPath.row].priceTitle ?? ""
        cell.cost.text = AppDelegate.CommonCartItems?.items[indexPath.row].priceValue ?? ""
        cell.inPackage.text = AppDelegate.CommonCartItems?.items[indexPath.row].InPackage ?? ""
        cell.quantity.text = AppDelegate.CommonCartItems?.items[indexPath.row].quantity ?? ""
        cell.OrderImage.sd_setImage(with: URL(string: AppDelegate.CommonCartItems?.items[indexPath.row].productImage ?? ""))
        cell.Delet.tag = indexPath.row
        cell.Plus.tag = indexPath.row
        cell.Minus.tag = indexPath.row
        cell.Save.tag = indexPath.row
        cell.Save.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
