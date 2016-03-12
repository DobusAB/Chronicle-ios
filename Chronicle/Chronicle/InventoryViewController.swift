//
//  InventoryViewController.swift
//  Chronicle
//
//  Created by Sebastian Marcusson on 2016-03-12.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class InventoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var itemsArray = [Item]()
    
    @IBOutlet weak var currentProgress: UIProgressView!
    @IBOutlet weak var currentLevel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var itemImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let items = realm.objects(Item)
        for item in items {
            itemsArray.append(item)
        }
        self.collectionVIew.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ItemCollectionViewCell
        let url = NSURL(string: itemsArray[indexPath.row].thumbnail)
        
        if itemsArray[indexPath.row].thumbnail.isEmpty {
            cell.ItemImage.image = UIImage(named: "treasure-closed")
            return cell
        } else {
            cell.ItemImage.sd_setImageWithURL(url, completed: nil)
            return cell
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailController = segue.destinationViewController as! DetailViewController
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionVIew.indexPathForCell(cell){
                let id = itemsArray[indexPath.row].itemId
                detailController.itemId = id
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
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
