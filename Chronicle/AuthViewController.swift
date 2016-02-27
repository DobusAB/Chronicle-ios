//
//  AuthViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    var chronicleBlue = UIColor(red:0.25, green:0.52, blue:1.0, alpha:1.0)
    var facebookBlue = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1.0)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Already logged in")
        } else {
            print("Please login")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = chronicleBlue
        facebookButton.backgroundColor = facebookBlue
        facebookButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        facebookButton.layer.cornerRadius = 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authAction(sender: AnyObject) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email", "public_profile"], fromViewController: self, handler: { (fbResult, error) -> Void in
            if error == nil {
                self.connectWithChronicle(fbResult)
            } else {
                //Error logging in
                print (error)
            }
        })
    }
    
    func connectWithChronicle(fbResult: FBSDKLoginManagerLoginResult) {
        print(fbResult.token.tokenString)
        //
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
