//
//  ContactusController.swift
//  salonatcom
//
//  Created by mac on 10/27/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//

import UIKit

class ContactusController: common {
    
    var userType: String?
    var token: String?

    @IBOutlet var name : UITextField!
    @IBOutlet var phone : UILabel!
    @IBOutlet var whatsapp : UILabel!
    @IBOutlet var email : UITextField!
    @IBOutlet var body : UITextView!
    @IBAction func SendSuggestion(_ sender: Any?) {
        AlamofireUpload("https://services-apps.net/jaddastore/public/api/contact-us")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupShadowViewtop()
        Modules()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ok(reg:)))
        view.addGestureRecognizer(tap)
        setUserData()
        getApiToken()
        AppContacts("https://services-apps.net/jaddastore/public/api/app-contacts")
    }
    @objc func ok(reg : UITapGestureRecognizer){
        view.endEditing(true)
    }
    fileprivate func Modules(){
        name.delegate = self
        email.delegate = self
        setModules(name)
        setModules(email)
        setModules(body)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    fileprivate func setUserData(){
        email.text = CashedData.getUserEmail() ?? ""
        name.text = CashedData.getUserName() ?? ""
    }
    fileprivate func AlamofireUpload(_ url : String){
        self.loading()
        let headers = ["Content-Type": "application/json" ,
                       "Accept" : "application/json",
                       "Authorization": "Bearer \(token ?? "")"
        ]
        let parameters = [
            "name": name.text!,
            "email": email.text!,
            "message": body.text!
            ] as [String : Any]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: parameters, headers: headers) {
            (error, success , jsonData) in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if success{
                    self.body.text = ""
                    let alert = common.makeAlert( message: "تم الارسال بنجاح")
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    let alert = common.makeAlert(message: dataRecived.message ?? "")
                    self.present(alert, animated: true, completion: nil)
                }
                
            } catch {
                let alert = common.makeAlert()
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
    }
    fileprivate func AppContacts(_ url : String){
        self.loading()
        let headers = ["Content-Type": "application/json" ,
                       "Accept" : "application/json",
        ]
        AlamofireRequests.PostMethod(methodType: "Get", url: url, info: [:], headers: headers) {
            (error, success , jsonData) in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if success{
                    let dataRecived = try decoder.decode(Contacts.self, from: jsonData)
                    self.whatsapp.text = dataRecived.data[0].whatsapp
                    self.phone.text = dataRecived.data[0].phone
                }
                else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    let alert = common.makeAlert(message: dataRecived.message ?? "")
                    self.present(alert, animated: true, completion: nil)
                }
                
            } catch {
                let alert = common.makeAlert()
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
    }
    func getApiToken() {
        token = CashedData.getUserUpdateKey() ?? ""
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
    fileprivate func setupShadowViewtop(){
        common.setNavigationShadow(navigationController: self.navigationController)
    }
}
extension ContactusController : UITextFieldDelegate {
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

