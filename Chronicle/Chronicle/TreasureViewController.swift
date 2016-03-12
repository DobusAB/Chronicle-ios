//
//  TreasureViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-03-12.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit

class TreasureViewController: UIViewController {

    @IBOutlet weak var modalContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var treasurechest: UIImageView!
    
    override func viewWillAppear(animated: Bool) {

        treasurechest.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        treasurechest.addGestureRecognizer(tapRecognizer)
        treasurechest.image = UIImage(named: "treasure-closed")
        
        UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
           // self.treasurechest.layer.position.y = botOriginalY + 90
           // self.treasurechest.layer.position.y = botOriginalY + 38
            
            }, completion: nil)
        
        
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        print("CLIIIIICKED")
        let imageName = "spaceship.pdf"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        self.treasurechest.addSubview(imageView)
        imageView.center = CGPointMake(treasurechest.frame.size.width  / 2,
            treasurechest.frame.size.height / 2);
        
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        treasurechest.image = UIImage(named: "treasure-open")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
