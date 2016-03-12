//
//  AuthViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    

    @IBOutlet weak var earthView: UIImageView!
    @IBOutlet weak var authButton: UIButton!
    let spaceBlue = UIColor(red:0.10, green:0.11, blue:0.16, alpha:1.0)
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton.backgroundColor = primaryBlue
        authButton.layer.shadowColor = primaryBlue.CGColor
        authButton.layer.shadowOffset = CGSizeMake(0, 0)
        authButton.layer.shadowRadius = 15
        authButton.layer.shadowOpacity = 0.9
        authButton.layer.cornerRadius = 27
        
        
        
        UIView.animateWithDuration(70, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
            self.earthView.transform = CGAffineTransformMakeRotation(CGFloat(-360))
            
            }, completion: nil)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let imageName = "spaceship.pdf"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        self.view.addSubview(imageView)
        let bounds = CGRect(x: 0, y: 0, width: 220, height: 220)
        let myView = UIView(frame: bounds)
        myView.center = self.view.center
        myView.layer.cornerRadius = bounds.width/2
        self.view.addSubview(myView)
        var orbit = CAKeyframeAnimation(keyPath: "position")
        orbit.fillMode = kCAGravityBottomRight
        orbit.path = CGPathCreateWithEllipseInRect(myView.layer.frame, nil)
        orbit.rotationMode = kCAAnimationRotateAuto
        orbit.removedOnCompletion = false
        orbit.repeatCount = Float.infinity
        orbit.duration = 80
        imageView.layer.addAnimation(orbit, forKey: "orbit")

        
        
        
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
