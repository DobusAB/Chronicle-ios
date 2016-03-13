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
    let primaryBlue = UIColor(red:0.22, green:0.52, blue:0.91, alpha:1.0)
    
    override func viewWillAppear(animated: Bool) {
        itemsArray.removeAll()
        let realm = try! Realm()
        let items = realm.objects(Item).filter("discovered = true")
        for item in items {
            itemsArray.append(item)
            print(item.itemLabel)
        }
        self.collectionVIew.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentProgress.progress = 0.8
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let realm = try! Realm()
        var user = realm.objects(User).first!
        var imgData = NSData(contentsOfFile: user.image)
        userImage.image = UIImage(data: imgData!)
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.blackColor().CGColor
        userImage.layer.borderWidth = 5.0
        
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
        
        cell.ItemImage.layer.cornerRadius = 3
        cell.ItemImage.clipsToBounds = true;
        cell.yearLabel.backgroundColor = primaryBlue
        cell.yearLabel.layer.cornerRadius = 12
        cell.layer.cornerRadius = 15
        cell.backgroundColor = primaryBlue
        cell.layer.cornerRadius = 4
        cell.photoBg.layer.cornerRadius = 2
        let itemLabelArr = itemsArray[indexPath.row].timeLabel.characters.split{$0 == " "}.map(String.init)
        cell.yearText.text = itemLabelArr[1]
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
        return CGSize(width: 100, height: 100)
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
