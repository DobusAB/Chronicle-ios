//
//  AuthViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    var chronicleBlue = UIColor(red:0.25, green:0.52, blue:1.0, alpha:1.0)
    var facebookBlue = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1.0)
    
    
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private let contentImages = ["facebook-icon",
        "facebook-icon",
        "facebook-icon",
        "facebook-icon"];
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
