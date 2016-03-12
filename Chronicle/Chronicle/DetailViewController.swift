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
    
    var itemId: String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(itemId)
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
    
        let realm = try! Realm()
        var item = realm.objects(Item).filter("itemId = '\(itemId)'")
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
