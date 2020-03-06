//
//  Network.swift
//
//  Created by Hassan Ramadan on 9/21/19.
//  Copyright © 2019 Hassan Ramadan IOS/Android Developer Tamkeen CO. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage

class AlamofireRequests {
    class func getMethod (url : String ,_ info: [String :Any ] = [:], headers: [String :String ] , complition :  @escaping (_ error:Error? ,_ success: Bool ,_ data:Data)->Void){
        
        Alamofire.request(url, method: .get, parameters: info, encoding: URLEncoding.queryString, headers: headers).responseData { (response) in
            switch response.result
            {
            case .failure(let error):
                complition(error, false , Data())
            case .success(let value):
                print (value)
                if let status = response.response?.statusCode {
                    if status >= 200 && status < 300{
                        complition(nil, true , value)
                    }else{
                        complition(nil, false , value)
                    }
                }else{
                    complition(nil, false , value)
                }
            }
        }
    }
    class func PostMethod (methodType: String, url : String , info: [String :Any ] , headers: [String :String ], complition :   @escaping (_ error:Error? ,_ success: Bool , _ data:Data) -> Void){
        
        
        let url = url
        let parameters = info
        let urlComponent = URLComponents(string: url)!
        let headers = headers
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = methodType
        request.timeoutInterval = 10
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.allHTTPHeaderFields = headers
        Alamofire.request(request).responseData { (response) in
            
            switch response.result {
            case .success(let value ):
                print("JSON: \(value)")
                if let status = response.response?.statusCode {
                    if status >= 200 && status < 300{
                        complition(nil, true , value)
                    }else{
                        complition(nil, false , value)
                    }
                }else{
                    complition(nil, false , value)
                }
            case .failure (let error):
                complition(error, false , Data())
            }
        }
        
    }
    
    class func adminSignUp (url : String , info: [String :Any ],images:[UIImage],CompanyImage: UIImage?,coverImage: UIImage?,idImage: UIImage?,licenseImage: UIImage?, headers: [String :String ], complition :   @escaping (_ error:Error? ,_ success: Bool , _ data:Data) -> Void){
        
        
        let url = url
        let params: Parameters = info
        //  self.post(url, params: params, handler: handler)
        
        ///////////////////////////////////////////
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            var i = 0
            for img in images {
                    let imgData = img.jpegData(compressionQuality: 0.1)!
                    multipartFormData.append(imgData, withName: "images[\(i)]",fileName: "images\(i+=1).png", mimeType: "image/jpg")
            }
            if CompanyImage != nil{
                let imgData = CompanyImage!.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: "image",fileName: "image.png", mimeType: "image/jpg")
            }
            if coverImage != nil{
                let imgData = coverImage!.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: "cover_image",fileName: "cover_image.png", mimeType: "image/jpg")
            }
            if idImage != nil{
                let imgData = idImage!.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: "id_image",fileName: "id_image.png", mimeType: "image/jpg")
            }
            if licenseImage != nil{
                let imgData = licenseImage!.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: "license_image",fileName: "license_image.png", mimeType: "image/jpg")
            }
            for (key, value) in params {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
            
        }, usingThreshold:UInt64.init(), to:url , method:.post, headers: headers){
            (result) in
            switch result {
            case .success(let upload, _ , _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Int(Progress.fractionCompleted*1000))")
                })
                
                upload.responseData { (response) in
                    switch response.result {
                    case .success(let value ):
                        if let status = response.response?.statusCode {
                            if status >= 200 && status < 300{
                                complition(nil, true , value)
                            }else{
                                complition(nil, false , value)
                            }
                        }else{
                            complition(nil, false , value)
                        }
                    case .failure (let error):
                        complition(error, false , Data())
                        print(error)
                    }
                }
            case .failure(let error):
                complition(error, false , Data())
                print(error)
                break
            }
        }
    }
    
    class func uploadMethod (url : String , info: [String :Any ],images:[UIImage],imageName: String, headers: [String :String ], complition :   @escaping (_ error:Error? ,_ success: Bool , _ data:Data) -> Void){
        
        
        let url = url
        let params: Parameters = info
        //  self.post(url, params: params, handler: handler)
        
        ///////////////////////////////////////////
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for img in images {
                let imgData = img.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: imageName,fileName: imageName+".png", mimeType: "image/jpg")
            }
            for (key, value) in params {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
            
        }, usingThreshold:UInt64.init(), to:url , method:.post, headers: headers){
            (result) in
            switch result {
            case .success(let upload, _ , _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseData { (response) in
                    
                    switch response.result {
                    case .success(let value ):
                        print("JSON: \(value)")
                        if let status = response.response?.statusCode {
                            if status >= 200 && status < 300{
                                complition(nil, true , value)
                            }else{
                                complition(nil, false , value)
                            }
                        }else{
                            complition(nil, false , value)
                        }
                    case .failure (let error):
                        complition(error, false , Data())
                    }
                }
            case .failure(let error):
                complition(error, false , Data())
                break
            }
        }
    }
    
    class func EditMethod (url : String , info: [String :Any ],images:[UIImage],imageName: [String], headers: [String :String ], complition :   @escaping (_ error:Error? ,_ success: Bool , _ data:Data) -> Void){
        
        
        let url = url
        let params: Parameters = info
        //  self.post(url, params: params, handler: handler)
        
        ///////////////////////////////////////////
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index,img) in images.enumerated() {
                let imgData = img.jpegData(compressionQuality: 0.1)!
                multipartFormData.append(imgData, withName: imageName[index],fileName: imageName[index]+".png", mimeType: "image/jpg")
            }
            for (key, value) in params {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
            
        }, usingThreshold:UInt64.init(), to:url , method:.post, headers: headers){
            (result) in
            switch result {
            case .success(let upload, _ , _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseData { (response) in
                    
                    switch response.result {
                    case .success(let value ):
                        print("JSON: \(value)")
                        if let status = response.response?.statusCode {
                            if status >= 200 && status < 300{
                                complition(nil, true , value)
                            }else{
                                complition(nil, false , value)
                            }
                        }else{
                            complition(nil, false , value)
                        }
                    case .failure (let error):
                        complition(error, false , Data())
                    }
                }
            case .failure(let error):
                complition(error, false , Data())
                break
            }
        }
    }
    
    
    class func getPhoto (url: String , complition :   @escaping (_ error:Error? ,_ success: Bool , _ photo: UIImage ) -> Void){
        let  imageUrl =  url
        Alamofire.request(imageUrl, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            // Do stuff with your image
            complition(nil,true , image)
        }
    }
    
}
