//
//  UserOrdersController.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class UserOrdersController: common {
    var myOrders = [OrdersDetails]()
    @IBOutlet var tableView : UITableView!
    @IBOutlet var rejected : UIButton!
    @IBOutlet var completed : UIButton!
    @IBOutlet var pended : UIButton!
    @IBAction func pending(_ sender: UIButton) {
        pended.setTitleColor(UIColor(named: "dark blue"), for: .normal)
        completed.setTitleColor(.black, for: .normal)
        rejected.setTitleColor(.black, for: .normal)
        getOrdersData(url: getUrl(status: "sent"))
    }
    @IBAction func completing(_ sender: UIButton) {
        pended.setTitleColor(.black, for: .normal)
        completed.setTitleColor(UIColor(named: "dark blue"), for: .normal)
        rejected.setTitleColor(.black, for: .normal)
        getOrdersData(url: getUrl(status: "completed"))
    }
    @IBAction func rejecting(_ sender: UIButton) {
        pended.setTitleColor(.black, for: .normal)
        completed.setTitleColor(.black, for: .normal)
        rejected.setTitleColor(UIColor(named: "dark blue"), for: .normal)
        getOrdersData(url: getUrl(status: "rejected"))
    }
    func getUrl(status: String) -> String {
        return "https://services-apps.net/jaddastore/public/api/my-orders?status=\(status)"
    }
    func getApiToken() -> String {
        return CashedData.getUserUpdateKey()!
    }
    override func viewWillAppear(_ animated: Bool) {
            let token = CashedData.getUserUpdateKey() ?? ""
            if token == ""{
                showCustomDialog()
            }else {
                pending(pended)
                getOrdersData(url: getUrl(status: "sent"))
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getOrdersData(url: String){
        loading()
        let headers = [
            "Authorization": "Bearer " + getApiToken()
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(UserOrders.self, from: jsonData)
                    if success{
                        self.myOrders = dataRecived.data
                        self.tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails" {
            if let destination = segue.destination as? OrderDetailsController{
                destination.OrderId = sender as? Int
            }
        }
    }
}
extension UserOrdersController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrders", for: indexPath) as! userOrderCell
        cell.date.text = self.myOrders[indexPath.row].createdAt
        cell.orderNumber.text = self.myOrders[indexPath.row].shippingId
        cell.salary.text = self.myOrders[indexPath.row].totalCost
        cell.process.text = Status(ApiStatus: self.myOrders[indexPath.row].status)
        cell.processIcon.image = StatusIcon(ApiStatus: self.myOrders[indexPath.row].status)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "orderDetails", sender: self.myOrders[indexPath.row].id)
    }
    func Status(ApiStatus : String)-> String{
        switch ApiStatus {
        case "preview":
            return "قيد المعاينة"
        case "completed":
            return "جارى التجهيز"
        default:
            return "تم الرفض"
        }
    }
    func StatusIcon(ApiStatus : String)-> UIImage{
        switch ApiStatus {
        case "preview":
            return #imageLiteral(resourceName: "status_orange")
        case "completed":
            return #imageLiteral(resourceName: "status_blue")
        default:
            return #imageLiteral(resourceName: "status_green")
        }
    }
}
