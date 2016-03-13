//
//  DetailViewController.swift
//  
//
//  Created by Albin Martinsson on 2016-03-12.
//
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var detailYearLabel: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailInfoContainer: UIView!
    @IBOutlet weak var detailPhotoBg: UIView!
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    
    @IBOutlet weak var itemDetail: UILabel!
    var itemId: String = ""
    
    
    @IBOutlet weak var detailSmallLabel: UIView!
    @IBOutlet weak var detailSmallLabelText: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        detailSmallLabel.backgroundColor = primaryBlue
        detailSmallLabel.layer.cornerRadius = 12
        
        detailInfoContainer.layer.shadowOffset = CGSizeMake(0, -5)
        detailInfoContainer.layer.shadowRadius = 5
        detailInfoContainer.layer.shadowOpacity = 0.15
        detailInfoContainer.layer.shadowColor = UIColor.blackColor().CGColor
        detailPhotoBg.backgroundColor = primaryBlue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let realm = try! Realm()
        let item = realm.objects(Item).filter("itemId = '\(itemId)'")
        let url = NSURL(string: item[0].thumbnail)
        
        print(url)
        
        if url == "" {
            detailImageView.image = UIImage(named: "image-placeholder")
        }
        else {
            detailImageView.sd_setImageWithURL(url, completed: nil)
        }

        detailName.text = item[0].itemLabel.capitalizedString
        itemDetail.text = item[0].itemType.capitalizedString
        itemDescriptionLabel.text = item[0].itemDescription.capitalizedString

        let itemLabelArr = item.first!.timeLabel.characters.split{$0 == " "}.map(String.init)
        detailYearLabel.text = itemLabelArr[1]
        detailSmallLabelText.text = itemLabelArr[1]
        
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
