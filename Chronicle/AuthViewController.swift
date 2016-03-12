//
//  AuthViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    

    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var botImage: UIImageView!


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let botOriginalY = botImage.frame.origin.y
        authButton.backgroundColor = UIColor(red:0.32, green:0.62, blue:1.00, alpha:1.0)
        authButton.layer.zPosition = 1
        authButton.layer.shadowColor = UIColor.blackColor().CGColor
        authButton.layer.shadowOffset = CGSizeMake(0, -5)
        authButton.layer.shadowRadius = 7
        authButton.layer.shadowOpacity = 0.5
        
        
        UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
            self.botImage.layer.position.y = botOriginalY + 190
            
            }, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authAction(sender: AnyObject) {
        
        performSegueWithIdentifier("SetupSegue", sender: self)
        
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
