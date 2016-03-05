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
    @IBOutlet weak var botImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        var botOriginalY = botImage.frame.origin.y
        print(botOriginalY)
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        setupButton.backgroundColor = UIColor(red:0.32, green:0.62, blue:1.00, alpha:1.0)
        setupButton.layer.zPosition = 1
        setupButton.layer.shadowColor = UIColor.blackColor().CGColor
        setupButton.layer.shadowOffset = CGSizeMake(0, -3)
        setupButton.layer.shadowRadius = 4
        setupButton.layer.shadowOpacity = 0.2
        inputLabel.layer.cornerRadius = 17;
        inputLabel.clipsToBounds = true;
        inputLabel.backgroundColor = UIColor(red:0.32, green:0.62, blue:1.00, alpha:1.0)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: nameInput.frame.size.height - width, width:  nameInput.frame.size.width, height: nameInput.frame.size.height)
        
        border.borderWidth = width
        nameInput.layer.addSublayer(border)
        nameInput.layer.masksToBounds = true
        
        UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
            self.botImage.layer.position.y = botOriginalY + 90
            self.shadowImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            }, completion: nil)
        
        // Do any additional setup after loading the view.
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
