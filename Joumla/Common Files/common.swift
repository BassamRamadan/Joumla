//
//  common.swift
//  Tourist-Guide
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import PopupDialog
class common : UIViewController , NVActivityIndicatorViewable{
    
    
    class func openNotify(sender : Any){
        let storyboard = UIStoryboard(name: "MyAccount", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
        (sender as AnyObject).show(linkingVC, sender: sender)
    }
    
    class func drowbackButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_arrow"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowFavButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_fav_white"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowShareButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(#imageLiteral(resourceName: "ic_share_white"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 30, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func openback(sender : UINavigationController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "LanuchScreenViewController")
        sender.present(linkingVC, animated: true, completion: nil)
        sender.popViewController(animated: true)
        sender.dismiss(animated: true, completion: nil)
    }
    
    class func setNavigationShadow(navigationController: UINavigationController?){
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
    }
    class func isSaloonLogedin()-> Bool{
        let token = CashedData.getAdminApiKey() ?? ""
        if token.isEmpty{
            return false
        }else{
            return true
        }
        
    }
    class func isUserLogedin()-> Bool{
        let token = CashedData.getUserApiKey() ?? ""
        if token.isEmpty{
            return false
        }else{
            return true
        }
        
    }
    
    class func userLogout(currentController: UIViewController){
            CashedData.saveUserUpdateKey(token: "")
            CashedData.saveUserApiKey(token: "")
            CashedData.saveUserPhone(name: "")
            CashedData.saveUserName(name: "")
            CashedData.saveUserEmail(name: "")
            CashedData.saveUserImage(name: "")
            openMain(currentController: currentController)
    }
    class func openMain(currentController: UIViewController){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
    func loading(_ message:String = ""){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", type: NVActivityIndicatorType.lineSpinFadeLoader)
    }
    
    class func makeAlert( message: String = "عفوا حدث خطأ في الاتصال من فضلك حاول مره آخري") -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default,.cancel,.destructive:
                print("default")
            @unknown default:
                print("default")
            }}))
        return alert
    }
    
    class func callWhats(whats: String,currentController: UIViewController) {
        var fullMob: String = whats
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                    })
                } else {
                    currentController.present(common.makeAlert(message:NSLocalizedString("WhatsApp Not Found on your device", comment: "")), animated: true, completion: nil)
                }
            }
        }
    }
    func showCustomDialog(animated: Bool = true) {
        // Create a custom view controller
        let loginVC = LoginViewController(nibName: "loginViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: loginVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        present(popup, animated: animated, completion: nil)
    }
    
    func setupBackButtonWithPOP() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.POP), for: UIControl.Event.touchUpInside)
    }
    func setupBackButtonWithDismiss() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
    }
    @objc func Dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
    @objc func POP() {
        self.navigationController?.popViewController(animated: true)
    }
}
