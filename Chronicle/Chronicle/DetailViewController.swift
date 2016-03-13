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
    
    @IBOutlet weak var detailYearLabel: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailInfoContainer: UIView!
    @IBOutlet weak var detailPhotoBg: UIView!
    @IBOutlet weak var yearText: UILabel!
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    
    @IBOutlet weak var itemDetail: UILabel!
    var itemId: String = ""
    
    @IBOutlet weak var childrenSectionLabel: UIView!
    @IBOutlet weak var childrenSectionText: UILabel!
    @IBOutlet weak var childrenThen: UILabel!
    @IBOutlet weak var childrenNow: UILabel!
   
    
    @IBOutlet weak var ageSectionLabel: UIView!
    @IBOutlet weak var ageSectionText: UILabel!
    @IBOutlet weak var ageThen: UILabel!
    @IBOutlet weak var ageNow: UILabel!
    
    
    
    @IBOutlet weak var detailSmallLabel: UIView!
    @IBOutlet weak var detailSmallLabelText: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        detailSmallLabel.backgroundColor = primaryBlue
        detailSmallLabel.layer.cornerRadius = 12
        
        childrenSectionLabel.backgroundColor = primaryBlue
        childrenSectionLabel.layer.cornerRadius = 12
        
        ageSectionLabel.backgroundColor = primaryBlue
        ageSectionLabel.layer.cornerRadius = 12
        
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
        let childMortality = realm.objects(ChildMortality)
        //childrenThen.text = childMortality.deathCount
        print(childMortality)
        
        print(url)
        
        if url == "" {
            detailImageView.image = UIImage(named: "bot_face")
        }
        else {
            detailImageView.sd_setImageWithURL(url, completed: nil)
        }

        detailName.text = item[0].itemLabel.capitalizedString
        itemDetail.text = item[0].itemType.capitalizedString

        let itemLabelArr = item.first!.timeLabel.characters.split{$0 == " "}.map(String.init)
        detailYearLabel.text = itemLabelArr[1]
        detailSmallLabelText.text = itemLabelArr[1]
        yearText.text = itemLabelArr[1]
        
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
