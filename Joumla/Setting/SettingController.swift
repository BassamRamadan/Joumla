//
//  MoreController.swift
//  Tourist-Guide
//
//  Created by Bassam Ramadan on 11/8/19.
//  Copyright © 2019 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class SettingController: common {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet var imageView: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        self.navigationItem.title =  "الإعدادات"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            showCustomDialog()
        }
    }
    
    func setUserData() {
        name.text = CashedData.getUserName()
        if CashedData.getUserImage() == ""{
            imageView.image = #imageLiteral(resourceName: "user_img")
        }else{
            imageView.sd_setImage(with: URL(string: CashedData.getUserImage() ?? ""))
        }
    }
    
    @IBAction func logoutUser(_ sender: Any){
        common.userLogout(currentController: self)
    }
    @IBAction func shareAppAction(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [AppDelegate.stringWithLink], applicationActivities: nil)
        activityController.completionWithItemsHandler = { _, completed, _, _
            in
            if completed {
                print("completed")
            } else {
                print("canceled")
            }
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [""], applicationActivities: nil)
            
            // ios > 8.0
            if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityVC.popoverPresentationController?.sourceView = super.view
                
                //                activityVC.popoverPresentationController?.sourceRect = super.view.frame
            }
            present(activityVC, animated: true, completion: nil)
        } else {
            present(activityController, animated: true) {
                print("presented")
            }
        }
    }
    
    @IBAction func editMyData(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserSignup", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "UserEditDataNavigation") as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
}

