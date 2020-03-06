//
//  UserAccount.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/2/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
class UserAccount: common,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let myPicController = UIImagePickerController()
    var images : UIImage?

    
    @IBOutlet var name : UILabel!
    @IBOutlet var phone : UILabel!
    @IBOutlet var email : UILabel!
    @IBOutlet var image : UIImageView!
    @IBOutlet var camera : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        roundCorners(cornerRadius: 10)
        myPicController.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = CashedData.getUserApiKey() ?? ""
        if token == ""{
            showCustomDialog()
        }
    }
    func setupData(){
        name.text = CashedData.getUserName()
        phone.text = CashedData.getUserPhone()
        email.text = CashedData.getUserEmail()
        image.sd_setImage(with: URL(string: CashedData.getUserImage() ?? ""))
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
            images = returnImage
            image.image = returnImage
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
}
