//
//  OrderPayment.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class OrderDetailsController: common {

    var OrderId : Int!
    var Purchases : OrderInformation?
    @IBOutlet weak var OrderNumber: UILabel!
    @IBOutlet weak var OrderDate: UILabel!
    @IBOutlet weak var TotalPurchases: UILabel!
    @IBOutlet weak var ShippingTo: UILabel!
    @IBOutlet weak var ShippingName: UILabel!
    @IBOutlet weak var ShippingType: UILabel!
    @IBOutlet weak var ShippingPhone: UILabel!
    @IBOutlet weak var PaymentName: UILabel!
    @IBOutlet weak var TotalCost: UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var tableViewHieght : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButtonWithPOP()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getOrdersData(url: "https://services-apps.net/jaddastore/public/api/my-orders/\(self.OrderId!)")
    }
    
    fileprivate func UpdateConstraints(){
        self.tableView.layoutIfNeeded()
        self.tableViewHieght.constant = self.tableView.contentSize.height
    }
    fileprivate func setData(){
        self.TotalPurchases.text = "\(self.Purchases?.items.count ?? 0)"
        self.TotalCost.text = self.Purchases?.totalCost
        self.OrderDate.text = self.Purchases?.createdAt
        self.OrderNumber.text = "\(self.Purchases?.id ?? 00)"
        self.PaymentName.text = self.Purchases?.shippingData.payment.name
        self.ShippingName.text = self.Purchases?.shippingData.name
        self.ShippingType.text = self.Purchases?.shippingData.type
        self.ShippingPhone.text = self.Purchases?.shippingData.phone
        self.ShippingTo.text = self.Purchases?.shippingData.address
    }
    func getOrdersData(url: String){
        loading()
        let headers = [
            "Authorization": "Bearer " + CashedData.getUserUpdateKey()!
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(OrderDetails.self, from: jsonData)
                    if success{
                        self.Purchases = dataRecived.data
                        self.tableView.reloadData()
                        self.UpdateConstraints()
                        self.setData()
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
extension OrderDetailsController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Purchases?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayment", for: indexPath) as! OrdersCell
        cell.orderName.text = self.Purchases?.items[indexPath.row].Pricetitle
        cell.bio.text = self.Purchases?.items[indexPath.row].product.name
        cell.OrderImage.sd_setImage(with: URL(string: self.Purchases?.items[indexPath.row].product.imagePath ?? ""))
        cell.quantity.text = self.Purchases?.items[indexPath.row].quantity
        cell.inPackage.text = self.Purchases?.items[indexPath.row].InPackage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
