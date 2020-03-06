//
//  LoginViewController.swift
//
//  Created by Hassan Ramadan on 9/21/19.
//  Copyright © 2019 Hassan Ramadan IOS/Android Developer Tamkeen CO. All rights reserved.
//

//

import UIKit
import NVActivityIndicatorView


class LoginViewController: UIViewController ,  NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Modules()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ok(reg:)))
        view.addGestureRecognizer(tap)
    }
    fileprivate func Modules(){
        userName.delegate = self
        password.delegate = self
        setModules(userName)
        setModules(password)
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserSignup", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "UserEditDataNavigation")  as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
    @IBAction func PopDown(_ sender: Any) {
        super.dismiss(animated: true)
    }
    
    @IBAction func log(_ sender: UIButton) {
        let url = "https://services-apps.net/jaddastore/public/api/login"
        let info = ["name": userName.text!,
                    "password": password.text!
        ]
        
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json"
        ]
        AlamofireRequests.PostMethod( methodType: "POST", url: url, info: info, headers: headers) { (error, success , jsonData) in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        let dataRecived = try decoder.decode(User.self, from: jsonData)
                        let user = dataRecived.data
                        CashedData.saveUserApiKey(token: user?.accessToken ?? "")
                        CashedData.saveUserUpdateKey(token: user?.accessToken ?? "")
                        CashedData.saveUserPhone(name:  user?.phone ?? "")
                        CashedData.saveUserName(name: user?.name ?? "")
                        CashedData.saveUserEmail(name: user?.email ?? "")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabUserController
                        linkingVC.index = 1
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = linkingVC
                        
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    }
                }else{
                    self.present(common.makeAlert(), animated: true, completion: nil)
                }
            }catch {
                self.present(common.makeAlert(message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func check(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "ic_chcek") {
            sender.setImage(#imageLiteral(resourceName: "ic_chcek_active"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_chcek"), for: .normal)
        }
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "UserSignup", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "SignUpNavigation")  as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
    
    func initialize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        print("initialize analatics service ")
    }
    
    @objc func ok(reg : UITapGestureRecognizer){
        view.endEditing(true)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "light blue")?.cgColor
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setModules(textField)
    }
}
