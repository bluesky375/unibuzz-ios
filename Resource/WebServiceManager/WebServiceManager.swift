//
//  WebServiceManager.swift
//  Thoubk
//
//  Created by Nouman Tariq on 9/7/16.
//  Copyright © 2016 ilsainteractive. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SVProgressHUD


enum MappingResult<T> {
    case asSelf(T)
    case asDictionary([String: T])
    case asArray([T])
    case raw(Data)
}


class WebServiceManager: NSObject  {
    
    static var serviceCount = 0
    
    //    class func progressHudSetting()  {
    //        SVProgressHUD.setCornerRadius(40)
    //        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.4199832678, green: 0.5878410339, blue: 0.8676598668, alpha: 1))
    //        SVProgressHUD.setForegroundColor(UIColor.init(named: "text_color")!)
    //        SVProgressHUD.setBorderColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    //        SVProgressHUD.setBorderWidth(1)
    //    }
    
    class func get<T: AnyObject>(params: Dictionary<String, AnyObject>?, serviceName: String, serviceType: String, modelType: T.Type, success: @escaping (_ servicResponse: AnyObject) -> Void, fail: (_ error: NSError) -> Void) where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            //        SVProgressHUD.show()
            
            showNetworkIndicator()
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "application/json"
            ]
            
            Alamofire.request(serviceName, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<T>) in
                hideNetworkIndicator()
                print(response)
                switch response.result {
                case .success(let objectData):
                    guard let this = try? self else {
                        return
                    }
                    print(objectData)
                    SVProgressHUD.dismiss()
                    success(objectData)
                    break
                case .failure(let error):
                    //                SVProgressHUD.dismiss()
                    
                    print(error.localizedDescription)
                }
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //      funcpresent UIViewController) {
    //            let AC = UIAlertController(title: KMessageTitle, message: KValidationOFInternetConnection, preferredStyle: .alert)
    //            let okBtn = UIAlertAction(title: "GO TO LOCATION", style: .default, handler: {(_ action: UIAlertAction) -> Void in
    //            })
    //            let noBtn = UIAlertAction(title: "CANCEL", style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
    //            })
    //            AC.addAction(okBtn)
    //            AC.addAction(noBtn)
    //            view.parent?.present(AC, animated: true, completion: {
    //            })
    //    //        view.parent!.present(AC, animated: true, completion: { _ in })
    //
    //        }
    
    class func getWithOutHeader<T: AnyObject>(params: Dictionary<String, AnyObject>?, serviceName: String, serviceType: String, modelType: T.Type, success: @escaping (_ servicResponse: AnyObject) -> Void, fail: (_ error: NSError) -> Void) where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            //        SVProgressHUD.show()
            
            showNetworkIndicator()
            let headers: HTTPHeaders = [
                "Accept" : "application/json" ,
            ]
            
            Alamofire.request(serviceName, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<T>) in
                hideNetworkIndicator()
                print(response)
                switch response.result {
                case .success(let objectData):
                    print(objectData)
                    SVProgressHUD.dismiss()
                    success(objectData)
                    break
                case .failure(let error):
                    //                SVProgressHUD.dismiss()
                    
                    print(error.localizedDescription)
                }
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func postJson<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        
        //        SVProgressHUD.show()
        
        //        if showHUD {
        //        }
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "application/json"
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func postJsonWithOutHeader<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            
            var userObj : Session?
            
            let headers: HTTPHeaders = [
                "Accept" : "application/json" ,
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func putJson<T: AnyObject>(params: Dictionary<String, Any>, serviceName: String, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        
        //        SVProgressHUD.show()
        
        //        if showHUD {
        //        }
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "application/json"
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .put, parameters: params , encoding: JSONEncoding.default, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        }  else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    class func post<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, isLoaderShow : Bool , serviceType: String , isMultipart : Bool , modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool )  where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            if showHUD {
                //            SVProgressHUD.show()
            }
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders?
            headers =             ["Authorization":  headerPath ,
                                   "Accept" : "application/json" ,
                                   "Content-Type" : "application/json"]
            
            
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func postWithOutHeader<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, isLoaderShow : Bool , serviceType: String , isMultipart : Bool , modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool )  where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            if showHUD {
                
            }
            SVProgressHUD.show()
            let headers: HTTPHeaders?
            headers =             [
                "Accept" : "application/json"
            ]
            
            
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func put<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, isLoaderShow : Bool , serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var userObj : Session?
            
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
            let jsonString = String(data: jsonData, encoding: .ascii)
            print(jsonString!)
            
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "application/json"
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            Alamofire.request(serviceName, method: .put, parameters: params, encoding: URLEncoding.httpBody, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func delete<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, isLoaderShow : Bool , serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "application/json"
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            showNetworkIndicator()
            
            Alamofire.request(serviceName, method: .delete, parameters: params, encoding: URLEncoding.httpBody, headers: headers).validate().responseObject { (response : DataResponse<T>) in
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    //    class func post<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, isLoaderShow : Bool , serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
    //
    //        SVProgressHUD.show()
    //
    //        let headers: HTTPHeaders = [
    //            "Content-Type" : "application/x-www-form-urlencoded"
    //        ]
    //
    //        let manager = Alamofire.SessionManager.default
    //        manager.session.configuration.timeoutIntervalForRequest = 60
    //
    //        showNetworkIndicator()
    //
    //        Alamofire.request(serviceName, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseObject { (response : DataResponse<T>) in
    //            hideNetworkIndicator()
    //
    //
    //            switch response.result {
    //
    //            case.success(let objectData):
    //                print(response.result)
    //                SVProgressHUD.dismiss()
    //                success(objectData)
    //            case.failure(let error):
    //                print(error.localizedDescription)
    //                                SVProgressHUD.dismiss()
    //                fail(error as NSError)
    //            }
    //
    //        }
    //
    //    }
    
    
    
    class func multiPartImage<T: AnyObject>(params: Dictionary<String, Any>, serviceName: String,imageParam: String , imgFileName:String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: Any) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "multipart/form-data"
            ]
            
            //        SVProgressHUD.show()
            showNetworkIndicator()
            Alamofire.upload(multipartFormData:{ multipartFormData in
                if profileImage != nil {
                    
                    if let imageData = profileImage?.jpegData(compressionQuality: 0.0) {
                        multipartFormData.append(imageData, withName:imageParam, fileName:imgFileName, mimeType: "image/png")
                    }
                }
                
                for (key, value) in params {
                    
                    let val = value as? String
                    multipartFormData.append(val!.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                             usingThreshold:UInt64.init(),
                             to:serviceName,
                             method:.post,
                             headers:headers,
                             encodingCompletion: { encodingResult in
                                hideNetworkIndicator()
                                
                                
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        print(response.result.value as Any)
                                        SVProgressHUD.dismiss()
                                        if(response.result.value != nil){
                                            let convertedResponse = Mapper<UserResponse>().map(JSON:response.result.value as! [String : Any])
                                            //                            /let convertedResponse3 = Mapper<UploadedPostObject>().map
                                            success(convertedResponse as AnyObject)
                                        }else{
                                            success("no internet" as AnyObject)
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    SVProgressHUD.dismiss()
                                    fail(encodingError as NSError)
                                }
                                
            }
            )
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func multiPartURL<T: AnyObject>(params: Dictionary<String, Any>, serviceName: String, fileParam: String , fileName: String, serviceType: String, fileURL: URL , modelType: T.Type, success: @escaping ( _ servicResponse: Any) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "multipart/form-data"
            ]
            
            //        SVProgressHUD.show()
            showNetworkIndicator()
            
            Alamofire.upload(multipartFormData:{ multipartFormData in
                multipartFormData.append(fileURL, withName: fileParam)
                for (key, value) in params {
                    
                    let val = value as? String
                    multipartFormData.append(val!.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                             usingThreshold:UInt64.init(),
                             to:serviceName,
                             method:.post,
                             headers:headers,
                             encodingCompletion: { encodingResult in
                                hideNetworkIndicator()
                                
                                
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        print(response.result.value as Any)
                                        SVProgressHUD.dismiss()
                                        if(response.result.value != nil){
                                            let convertedResponse = Mapper<UserResponse>().map(JSON:response.result.value as! [String : Any])
                                            success(convertedResponse as AnyObject)
                                        }else{
                                            success("no internet" as AnyObject)
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    SVProgressHUD.dismiss()
                                    fail(encodingError as NSError)
                                }
                                
            }
            )
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func mutliChat<T: AnyObject>(params: Dictionary<String, Any>, serviceName: String,imageParam: String , imgFileName:String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: Any) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "multipart/form-data"
            ]
            
            //        SVProgressHUD.show()
            showNetworkIndicator()
            Alamofire.upload(multipartFormData:{ multipartFormData in
                if profileImage != nil {
                    if let imageData = profileImage?.jpegData(compressionQuality: 0.0) {
                        multipartFormData.append(imageData, withName:imageParam, fileName:imgFileName, mimeType: "image/png")
                    }
                }
                for (key, value) in params {
                    let val = value as! String
                    multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                             usingThreshold:UInt64.init(),
                             to:serviceName,
                             method:.post,
                             headers:headers,
                             encodingCompletion: { encodingResult in
                                hideNetworkIndicator()
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        print(response.result.value as Any)
                                        SVProgressHUD.dismiss()
                                        if(response.result.value != nil){
                                            let convertedResponse = Mapper<MessageObject>().map(JSON:response.result.value as! [String : Any])
                                            //                            /let convertedResponse3 = Mapper<UploadedPostObject>().map
                                            
                                            print(convertedResponse)
                                            success(convertedResponse as AnyObject)
                                        }else{
                                            success("no internet" as AnyObject)
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    SVProgressHUD.dismiss()
                                    fail(encodingError as NSError)
                                }
            }
            )
            
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //multipartFormData.appendBodyPart(fileURL: videoPathUrl!, name: "video")
    class func multiPartImageMorePhotos<T: AnyObject>(params: Dictionary<String, AnyObject>,morePhotos: [UIImage]?, serviceName: String,imageParam: String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            
            SVProgressHUD.show()
            //        progressHudSetting()
            showNetworkIndicator()
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "multipart/form-data"
            ]
            
            showNetworkIndicator()
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if let imageData = profileImage?.jpegData(compressionQuality: 0.0) {
                        multipartFormData.append(imageData, withName:"post_image", fileName:"post_image.png", mimeType: "image/png")
                    }
                    
                    if morePhotos != nil && (morePhotos?.count)! > 0 {
                        for (index, obj) in (morePhotos?.enumerated())! {
                            multipartFormData.append(WAShareHelper.compressImageWithAspectRatio(image: obj), withName: "more_image[\(index)]", fileName: "more_image\(index).png", mimeType: "image/png")
                        }
                        //                    }
                    }
                    
                    // import parameters
                    for (key, value) in params {
                        let val = value as! String
                        multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
                usingThreshold:UInt64.init(),
                to:serviceName,
                method:.post,
                headers:headers,
                encodingCompletion: { encodingResult in
                    hideNetworkIndicator()
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON { response in
                            print(response.result.value as Any)
                            SVProgressHUD.dismiss()
                            if(response.result.value != nil){
                                let convertedResponse = Mapper<UserResponse>().map(JSON:response.result.value as! [String : Any])
                                ///let convertedResponse3 = Mapper<UploadedPostObject>().map
                                success(convertedResponse as AnyObject)
                            }else{
                                let error = NSError()
                                fail(error)
                            }
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                        SVProgressHUD.dismiss()
                        fail(encodingError as NSError)
                    }
            }
            )
            
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    class func multiPartImageMorePhotosInChat<T: AnyObject>(params: Dictionary<String, AnyObject>,morePhotos: [UIImage]?, serviceName: String,imageParam: String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        if ConnectionCheck.isConnectedToNetwork() {
            
            
            SVProgressHUD.show()
            //        progressHudSetting()
            showNetworkIndicator()
            var userObj : Session?
            
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            
            let user_token =   userObj?.access_token
            let headerPath =  "Bearer \(user_token!)"
            let headers: HTTPHeaders = [
                "Authorization":  headerPath ,
                "Accept" : "application/json" ,
                "Content-Type" : "multipart/form-data"
            ]
            
            showNetworkIndicator()
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if morePhotos != nil && (morePhotos?.count)! > 0 {
                        for (index, obj) in (morePhotos?.enumerated())! {
                            
                            multipartFormData.append(WAShareHelper.compressImageWithAspectRatio(image: obj), withName: "message_files[\(index)]", fileName: "message_files\(index).png", mimeType: "image/png")
                        }
                    }
                    
                    // import parameters
                    for (key, value) in params {
                        let val = value as! String
                        multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
                usingThreshold:UInt64.init(),
                to:serviceName,
                method:.post,
                headers:headers,
                encodingCompletion: { encodingResult in
                    hideNetworkIndicator()
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON { response in
                            print(response.result.value as Any)
                            SVProgressHUD.dismiss()
                            if(response.result.value != nil){
                                let convertedResponse = Mapper<MessageObject>().map(JSON:response.result.value as! [String : Any])
                                ///let convertedResponse3 = Mapper<UploadedPostObject>().map
                                success(convertedResponse as AnyObject)
                            }else{
                                let error = NSError()
                                fail(error)
                            }
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                        SVProgressHUD.dismiss()
                        fail(encodingError as NSError)
                    }
            }
            )
            
        } else {
            
            let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showNetworkIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            WebServiceManager.serviceCount += 1
            
        }
    }
    
    class func hideNetworkIndicator() {
        WebServiceManager.serviceCount -= 1
        if WebServiceManager.serviceCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


