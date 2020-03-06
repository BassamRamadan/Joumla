//
//  SignUpController.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/29/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Photos
class SignUpController: common, UIImagePickerControllerDelegate ,
    UINavigationControllerDelegate {

    var isUserEditing : Bool = false
    var url : String = ""
    var methodType : String = ""
    let myPicController = UIImagePickerController()
    var image : UIImage?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var name : UITextField!
    @IBOutlet var phone : UITextField!
    @IBOutlet var email : UITextField!
    @IBOutlet var pass : UITextField!
    @IBOutlet var configPass : UITextField!
    @IBOutlet var camera : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        self.myPicController.delegate = self
        setupGesture()
        roundCorners(cornerRadius: 10)
        Modules()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ok(reg:)))
        view.addGestureRecognizer(tap)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationItem.title == "تعديل بياناتي"{
            name.text = CashedData.getUserName() ?? ""
            phone.text = CashedData.getUserPhone() ?? ""
            email.text = CashedData.getUserEmail() ?? ""
            url = "https://services-apps.net/jaddastore/public/api/edit-profile"
            methodType = "PUT"
            isUserEditing = true
        }else{
            name.text = ""
            phone.text = ""
            email.text = ""
            url = "https://services-apps.net/jaddastore/public/api/signup"
            methodType = "POST"
            isUserEditing = false
        }
    }
    fileprivate func Modules(){
        name.delegate = self
        email.delegate = self
        phone.delegate = self
        pass.delegate = self
        configPass.delegate = self
        setModules(name)
        setModules(email)
        setModules(phone)
        setModules(pass)
        setModules(configPass)
    }
    
    @IBAction func Accept(sender : UIButton){
        if sender.imageView?.image == #imageLiteral(resourceName: "ic_chcek") {
            sender.setImage(#imageLiteral(resourceName: "ic_chcek_active"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_chcek"), for: .normal)
        }
    }
    @IBAction func Policy(sender : UIButton){
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "PolicyNav") as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
    @IBAction func Submit(sender : UIButton){
        self.loading()
        let url = self.url
        var info : [String : Any] = [
            "name" : name.text ?? "",
            "phone" : phone.text ?? "",
            "email" : email.text ?? "",
            "password" : pass.text ?? "",
            "password_confirmation" : configPass.text ?? ""
        ]
        var headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        if isUserEditing{
            headers = [
                "Accept" : "application/json",
                "Content-Type" : "application/json",
                "Authorization": "Bearer \(CashedData.getUserUpdateKey() ?? "")"
            ]
            info = [
                "name" : name.text ?? "",
                "phone" : phone.text ?? "",
                "email" : email.text ?? "",
                "password" : pass.text ?? "",
                "password_confirmation" : configPass.text ?? "",
                "_method" : "PUT"
            ]
        }
        AlamofireRequests.PostMethod(methodType: self.methodType, url: url, info: info, headers: headers){
            (error, success , jsonData) in
            do {
                self.stopAnimating()
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        let dataRecived = try decoder.decode(User.self, from: jsonData)
                        let user = dataRecived.data
                        if self.isUserEditing == false{
                            CashedData.saveUserApiKey(token: user?.accessToken ?? "")
                            CashedData.saveUserUpdateKey(token: user?.accessToken ?? "")
                        }
                        CashedData.saveUserPhone(name:  user?.phone ?? "")
                        CashedData.saveUserName(name: user?.name ?? "")
                        CashedData.saveUserEmail(name: user?.email ?? "")
                        CashedData.saveUserPassword(name: self.pass.text ?? "")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabUserController
                        linkingVC.index = 1
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = linkingVC
                        
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    }
                }
            }catch {
                self.present(common.makeAlert(message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    func roundCorners(cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: camera.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = camera.bounds
        maskLayer.path = path.cgPath
        camera.layer.mask = maskLayer
    }
    @IBAction func pickImages(_ sender: UIButton) {
        checkPermission()
        myPicController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPicController , animated: true, completion: nil)
    }
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let returnImage =  info[.originalImage] as? UIImage   {
            image = returnImage
            userImage.image = returnImage
            
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default:
            print("User has denied the permission.")
        }
    }
    
    fileprivate func setupGesture(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tb(_:)))
        tapGes.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGes)
    }
    @objc func tb(_ tab : UITapGestureRecognizer){
        view.endEditing(true)
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
    
    @objc func ok(reg : UITapGestureRecognizer){
        view.endEditing(true)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
}
extension SignUpController : UITextFieldDelegate {
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
