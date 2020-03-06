//
//  UserOrdersController.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class UserOrdersController: common {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var rejected : UIButton!
    @IBOutlet var completed : UIButton!
    @IBOutlet var pended : UIButton!
    @IBAction func pending(_ sender: UIButton) {
        pended.setTitleColor(UIColor(named: "dark blue"), for: .normal)
        completed.setTitleColor(.black, for: .normal)
        rejected.setTitleColor(.black, for: .normal)
    }
    @IBAction func completing(_ sender: UIButton) {
        pended.setTitleColor(.black, for: .normal)
        completed.setTitleColor(UIColor(named: "dark blue"), for: .normal)
        rejected.setTitleColor(.black, for: .normal)
    }
    @IBAction func rejecting(_ sender: UIButton) {
        pended.setTitleColor(.black, for: .normal)
        completed.setTitleColor(.black, for: .normal)
        rejected.setTitleColor(UIColor(named: "dark blue"), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pending(pended)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            showCustomDialog()
        }
    }
  
}
extension UserOrdersController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrders", for: indexPath) as! userOrderCell
        
        return cell
    }
    
    
}
