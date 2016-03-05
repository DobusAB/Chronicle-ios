//
//  SetupViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-03-05.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var setupButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        setupButton.backgroundColor = UIColor(red:0.32, green:0.62, blue:1.00, alpha:1.0)
        setupButton.layer.zPosition = 1
        setupButton.layer.shadowColor = UIColor.blackColor().CGColor
        setupButton.layer.shadowOffset = CGSizeMake(0, -5)
        setupButton.layer.shadowRadius = 7
        setupButton.layer.shadowOpacity = 0.5
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
