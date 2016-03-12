//
//  SetupViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-03-05.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift

class SetupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet weak var botImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var botFaceImage: UIImageView!
    @IBOutlet weak var addProfileImageButton: UIButton!
    
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    let imagePicker = UIImagePickerController()

    
    override func viewWillAppear(animated: Bool) {
        
        let botOriginalY = botImage.frame.origin.y
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        setupButton.layer.cornerRadius = 27
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.borderWidth = width
        botFaceImage.layer.cornerRadius = botFaceImage.frame.size.width/2
        botFaceImage.clipsToBounds = true
        botFaceImage.layer.borderColor = UIColor.blackColor().CGColor
        botFaceImage.layer.borderWidth = 5.0
        
        
        if botFaceImage.image == UIImage(named: "bot_face") {
            
            setupButton.enabled = false
            setupButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
            setupButton.layer.shadowOffset = CGSizeMake(0, 0)
            setupButton.layer.shadowRadius = 0
            setupButton.layer.shadowOpacity = 0
            
        } else {
            
            setupButton.enabled = true
            
            
            UIView.animateWithDuration(0.25, delay:0.5, options: [], animations: {
                
                self.setupButton.layer.shadowColor = self.primaryBlue.CGColor
                self.setupButton.backgroundColor = self.primaryBlue
                self.setupButton.layer.shadowOffset = CGSizeMake(0, 0)
                self.setupButton.layer.shadowRadius = 10
                self.setupButton.layer.shadowOpacity = 0.7
                
                }, completion: nil)
            
        }

        
        UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
            self.botImage.layer.position.y = botOriginalY + 90
            self.botFaceImage.layer.position.y = botOriginalY + 38
            self.shadowImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            }, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func addProfileImage(sender: AnyObject) {
        print("Let's change your profile-pic")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            print("Button capture")
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.Camera;
            image.mediaTypes = [kUTTypeImage as String]
            image.allowsEditing = false
            
            self.presentViewController(image, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let imgData: NSData = UIImageJPEGRepresentation(image, 1.0)!
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let writePath = documentsPath.stringByAppendingString("/userimage.jpg")
        imgData.writeToFile(writePath, atomically: true)
        print(writePath)
        
        let user = User()
        user.userId = "1"
        user.image = writePath
        //Save item to realm if item has long/lat
        do {
            let realm = try Realm()
            try realm.write() {
                realm.add(user)
            }
            botFaceImage.image = image
        } catch {
            print("Something went wrong with realm!")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func activateBot(sender: AnyObject) {
        self.performSegueWithIdentifier("activateBotSegue", sender: nil)
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
