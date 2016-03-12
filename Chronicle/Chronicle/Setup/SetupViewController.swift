//
//  SetupViewController.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-03-05.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import MobileCoreServices


class SetupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet weak var botImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var botFaceImage: UIImageView!
    @IBOutlet weak var addProfileImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()

    
    override func viewWillAppear(animated: Bool) {
        
        let botOriginalY = botImage.frame.origin.y
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
        botFaceImage.layer.cornerRadius = botFaceImage.frame.size.width/2
        botFaceImage.clipsToBounds = true
        botFaceImage.layer.borderColor = UIColor.blackColor().CGColor
        botFaceImage.layer.borderWidth = 5.0
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("i've got an image");
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            
            let imageData: NSData = UIImagePNGRepresentation(pickedImage)!
            //print(imageData)
            let url = info[UIImagePickerControllerReferenceURL] as? NSURL
            print(url)
//            print(info[UIImagePickerControllerReferenceURL] as! String)
/*            if let hej = info[UIImagePickerControllerReferenceURL] as? NSURL {
                print(hej)
            }*/
            
        }
        //print(info)
        //let imageURL = info[UIImagePickerControllerReferenceURL] as! String
        //print(imageURL)
        
        //print(editingInfo)
        
        dismissViewControllerAnimated(true, completion: nil)
        //print(image)
        //botFaceImage.image = image
        
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
