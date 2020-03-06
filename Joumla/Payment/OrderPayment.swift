//
//  OrderPayment.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class OrderPayment: UIViewController {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var tableViewHieght : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateConstraints()
    }
    fileprivate func UpdateConstraints(){
        self.tableView.layoutIfNeeded()
        self.tableViewHieght.constant = self.tableView.contentSize.height
    }
}
extension OrderPayment : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayment", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
