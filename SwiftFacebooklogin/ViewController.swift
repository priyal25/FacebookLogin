//
//  ViewController.swift
//  SwiftFacebooklogin
//
//  Created by Priyal Jain on 12/8/16.
//  Copyright © 2016 Priyal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookLoginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton : FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        loginButton.readPermissions =
        ["public_profile", "email","user_friends"];
        view.addSubview(loginButton)
//        view.bringSubview(toFront: facebookLoginView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Login Button Delegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if ((error == nil) && (!result.isCancelled))
        {
            let grantedPermission = result.grantedPermissions
            for permission in grantedPermission!
            {
                print(permission)
            }
            let declinedPermission = result.declinedPermissions
            let accessToken = result.token
            print("Access Token is : \(accessToken)")
            print("Granted Permissions are : \(grantedPermission)")
            print("Declined Permissions are :\(declinedPermission)")
            fetchUserData()
        }
    
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
    
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    
    //MARK: Private Methods
    
    func fetchUserData ()
    {
        let parameters  = ["fields" : "email, first_name, last_name, picture.type(large)"]
        
        var id : String? = nil
        
        FBSDKGraphRequest.init(graphPath:"me", parameters: parameters).start { (connection, result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            var reformedResult = result as! [String : Any]
            if let email = reformedResult["email"] {
                print("Email of user is : \(email)")
            }
            if let firstName = reformedResult["first_name"]             {
                print("First name of user is : \(firstName)")
    
            }
            if let lastName = reformedResult["last_name"] {
                print("Last name of user is :\(lastName)")
            }
            if let userPicture = reformedResult["picture"] {
                print("Url for user picture is :\(userPicture)")
            }
            if let userId = reformedResult["id"] as! String? {
                print("Id of user is \(userId)")
                id = userId
            }
            if id != nil
            {
//                self.getFBFriends(withUserId: id!)
                self.getFacebookFriends(userId: id!)
            }
        }
        
        
    }
    
    func getFBFriends(withUserId:String){
        let parameters  = ["fields" : "user_friends"]
        let graphPath = "/" + withUserId
        print("Final graph path is \(graphPath)")
        FBSDKGraphRequest.init(graphPath:graphPath, parameters: parameters).start {
            (connection, result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            var reformedResult = result as! [String : Any]
            if let friends = reformedResult["user_friends"] {
                print(friends)
            }
        }
    }
    
    func getFacebookFriends (userId:String){
         let parameters  = ["fields" : "user_friends"]
        let request = FBSDKGraphRequest.init(graphPath: "/"+userId + "/friends", parameters: parameters, httpMethod: "GET")
        
        _ =  request?.start(completionHandler: { (connection, result, error) in
            let reformedResult = result as! [String : Any]
            print("Received facebook friends data are :\(reformedResult)")
        })
    }
    
    
    /*
     
     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
     initWithGraphPath:@"/{user-id}/friends"
     parameters:params
     HTTPMethod:@"GET"];
     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
     id result,
     NSError *error) {
     // Handle the result
     }];
     
     
     */
    
}


