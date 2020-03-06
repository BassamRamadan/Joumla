//
//  Trashing.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Trashing: common {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            showCustomDialog()
        }
    }

}
extension Trashing : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trashing", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
