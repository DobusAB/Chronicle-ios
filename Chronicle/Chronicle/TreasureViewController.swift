//
//  TreasureViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-03-12.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import pop

class TreasureViewController: UIViewController, UIDynamicAnimatorDelegate{

    @IBOutlet weak var modalContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var treasurechest: UIImageView!
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    
    override func viewWillAppear(animated: Bool) {
        
        treasurechest.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        treasurechest.addGestureRecognizer(tapRecognizer)
        treasurechest.image = UIImage(named: "treasure-closed")
        closeButton.backgroundColor = primaryBlue
        closeButton.layer.shadowColor = primaryBlue.CGColor
        closeButton.layer.shadowOffset = CGSizeMake(0, 0)
        closeButton.layer.shadowRadius = 15
        closeButton.layer.shadowOpacity = 0.9
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
    

    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        print("Opened Chest")
        let imageName = "spaceship.pdf"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        self.treasurechest.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.center = CGPointMake(treasurechest.frame.size.width  / 2,
            treasurechest.frame.size.height / 2 - 20)
        imageView.layer.opacity = 0
        treasurechest.userInteractionEnabled = false
        
    
        UIView.animateWithDuration(0.8, delay:0, options: [], animations: {
            
            //self.treasurechest.layer.position.y = self.treasurechest.layer.position.y - 15
            
            let spring = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
            spring.fromValue = 0
            spring.toValue = -20
            spring.springBounciness = 10
            spring.springSpeed = 10
            self.treasurechest.layer.pop_addAnimation(spring, forKey: "moveUp")
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay:0, options: [], animations: {
            
            imageView.layer.position.y = self.treasurechest.layer.position.y - 190
            imageView.layer.opacity = 1
            
            }, completion: nil)
        
        treasurechest.image = UIImage(named: "treasure-open")
        print("Chest just opened")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        treasurechest.layer.position.x = modalContainer.frame.midX/2 + 5
        treasurechest.layer.position.y = modalContainer.frame.midY - 700
        
        
        animator = UIDynamicAnimator(referenceView: modalContainer)
        gravity = UIGravityBehavior(items: [treasurechest])
        animator.addBehavior(gravity)
    
        collision = UICollisionBehavior(items: [treasurechest])
        //collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        collision.addBoundaryWithIdentifier("barrier", fromPoint: CGPointMake(self.view.frame.origin.x, 300), toPoint: CGPointMake(self.view.frame.origin.x + self.view.frame.width, 300))



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: AnyObject) {
        
       dismissViewControllerAnimated(true) { () -> Void in

        }
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
