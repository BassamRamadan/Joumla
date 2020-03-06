//
//  AboutUsController.swift
//  TouristGuide
//
//  Created by Bassam Ramadan on 11/2/19.
//  Copyright © 2019 Bassam Ramadan. All rights reserved.
//

import UIKit

class UsagePolicy: common {

    @IBOutlet weak var content: UILabel!
    var aboutData: AboutUSDataDetails?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        common.setNavigationShadow(navigationController: self.navigationController)
        self.tabBarController?.tabBar.isHidden = false
        self.getAboutData()
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func getAboutData() {
        self.loading()
        let url = "https://services-apps.net/jaddastore/public/api/policies"
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { error, success, jsonData in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(AboutUS.self, from: jsonData)
                        self.aboutData = dataReceived.data
                        self.content.text = self.aboutData?.content
                    } else {
                        let dataReceived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        let alert = common.makeAlert(message: dataReceived.message ?? "")
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                }
            } catch {
                let alert = common.makeAlert()
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidesBottomBarWhenPushed = true
    }
    func setupBackButton() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControl.Event.touchUpInside)
    }
    @objc func back() {
        self.navigationController?.dismiss(animated: true)
      //  self.navigationController?.popViewController(animated: true)
    }

}
