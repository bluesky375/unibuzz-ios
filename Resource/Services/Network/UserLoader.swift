//
//  UserLoader.swift
//  BeOrganic
//
//  Created by Waqas Ali on 12/30/16.
//  Copyright Â© 2016 KLARENZ. All rights reserved.
//

import Foundation

class UserLoader {
    
    //MARK:-
    var alamofire = UBManager()
    
    // MARK:- Public Methods
    func tryUpdateGPA(parameters:[String: AnyObject]?, successBlock success:@escaping ((_ user:FeedsResponse) -> Void), failureBlock failure:@escaping ((_ error: Error?) -> Void)) {
        self.alamofire.requestPutWithJSON(GETMYGPA2, parameters: parameters, authorized: true, success: { (response) in
            self.parseLoginUser(response.data!, successBlock: success, failureBlock: failure)
        }) { (error) in
            failure(error)
        }
    }
    
    //MARK:- Parse Methods
    
    //2
    fileprivate func parseLoginUser(_ response:Data, successBlock success:@escaping ((_ user:FeedsResponse) -> Void), failureBlock failure:@escaping ((_ error: Error?) -> Void)) {
        
        guard let object = try? JSONDecoder().decode(FeedsResponse.self, from: response) else {
            failure("Could not parse data" as? Error)
            return
        }
        
        object.process()
        success(object)
    }
    
    // MARK:- Public Methods
    func tryFriendsRequests(endPoint: String, parameters:[String: AnyObject]?, successBlock success:@escaping ((_ user:FeedsResponse) -> Void), failureBlock failure:@escaping ((_ error: Error?) -> Void)) {
        self.alamofire.requestPutWithJSON(endPoint, parameters: parameters, authorized: true, success: { (response) in
            self.parseLoginUser(response.data!, successBlock: success, failureBlock: failure)
        }) { (error) in
            failure(error)
        }
    }
}
