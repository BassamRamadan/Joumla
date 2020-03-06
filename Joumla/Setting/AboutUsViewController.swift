//
//  Created by Hassan Ramadan on 9/21/19.
//  Copyright © 2019 Hassan Ramadan IOS/Android Developer Tamkeen CO. All rights reserved.
//

import UIKit
import SDWebImage
class AboutUsViewController: common {

    @IBOutlet weak var content: UILabel!
    var aboutData: AboutUSDataDetails?
    override func viewDidLoad() {
     
        setupBackButton()
        super.viewDidLoad()
        common.setNavigationShadow(navigationController: self.navigationController)
        self.tabBarController?.tabBar.isHidden = false
        getAboutData()
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
    }
    fileprivate func getAboutData(){
        self.loading()
         let url = "https://services-apps.net/jaddastore/public/api/aboutus"
        let headers = [
            "Content-Type": "application/json" ,
                    "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(AboutUS.self, from: jsonData)
                        self.aboutData = dataReceived.data
                        self.content.text = self.aboutData?.content
                    }else{
                        let alert = UIAlertController(title: "تنبيه", message: "عفوا حدث خطأ في الاتصال من فضلك حاول مره آخري" , preferredStyle: UIAlertController.Style.alert)
                        self.present(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            switch action.style{
                            case .default ,.destructive ,.cancel:
                                self.getAboutData()
                            @unknown default:
                                self.getAboutData()
                            }}))
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
    fileprivate func setupShadowViewtop(){
        common.setNavigationShadow(navigationController: self.navigationController)
    }
}
