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
    
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailInfoContainer: UIView!
    
    @IBOutlet weak var itemDetail: UILabel!
    var itemId: String = ""
    
    
    override func viewWillAppear(animated: Bool) {
        
        detailInfoContainer.layer.shadowOffset = CGSizeMake(0, -10)
        detailInfoContainer.layer.shadowRadius = 5
        detailInfoContainer.layer.shadowOpacity = 0.25
        detailInfoContainer.layer.shadowColor = UIColor.blackColor().CGColor
        
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
        
        detailImageView.sd_setImageWithURL(url, completed: nil)
        
        detailName.text = item[0].itemLabel
        
        itemDetail.text = item[0].itemType
        
        
        print(item[0].itemLabel)
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
