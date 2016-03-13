//
//  AppDelegate.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import Foundation
import UIKit
import SWXMLHash
import RealmSwift
import JSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Ask user for push permission
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes([.Badge, .Sound, .Alert])
        }
        
       let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        var users: AnyObject?
        do {
            users = try JSON.from("barnadodlighet.json")
            if let usersDictionary = users!["data"] as? [NSDictionary] {
                //print(usersDictionary["data"]!)
                for user in usersDictionary {
                    let childM = ChildMortality()
                    childM.year = user["key"]![1] as! String
                    /*if let cD = user["values"]![0] as? String {
                        childM.deathCount = cD
                    }*/
                    childM.deathCount = user["values"]![0] as! String
                    print(childM.deathCount)
                    
                    //Save item to realm if item has long/lat
                    do {
                        let realm = try Realm()
                        try realm.write() {
                            realm.add(childM)
                        }
                    } catch {
                        print("Something went wrong with realm!")
                    }
                }
            }
            
        } catch {
            // Handle error
        }
        
         let realm = try! Realm()
        let childMortality = realm.objects(ChildMortality)
        //childrenThen.text = childMortality.deathCount
        print(childMortality)
        
        /*var ages: AnyObject?
        do {
            ages = try JSON.from("livslangd")
            if let agesDictionary = ages!["data"] as? [NSDictionary] {
                //print(usersDictionary["data"]!)
                for age in agesDictionary {
                    let yearY = Year()
                    yearY.year = age["key"]![1] as! String
                    if let cD = age["values"]![0] as? String {
                        yearY.age = cD
                    }
                    
                    //Save item to realm if item has long/lat
                    do {
                        let realm = try Realm()
                        try realm.write() {
                            realm.add(yearY)
                        }
                    } catch {
                        print("Something went wrong with realm!")
                    }
                }
            }
            
        } catch {
            // Handle error
        }*/
        
        clearRealm()
        initItems()
        
        return true
    }
    
    func initItems() {
        let xmlPath = NSBundle.mainBundle().pathForResource("data1", ofType: "xml")
        let data = NSData(contentsOfFile: xmlPath!)
        let xml = SWXMLHash.lazy(data!)
        let xmlItems = xml["result"]["records"]["record"]
        var lat: Double = 0.0;
        var long: Double = 0.0;
        var itemlabel: String? = "";
        var itemDescription: String? = "";
        var thumbnail: String = "";
        var itemType: String? = "";
        var id : String? = "";
        var timeLabel: String? = "";
        
        for items in xmlItems {
            var datan = items["rdf:RDF"]["rdf:Description"][0]
            
            if let dataId = datan["ns5:presentation"]["pres:item"]["pres:id"].element?.text {
                id = dataId
            }
            
            if let dataDescription = datan["ns5:presentation"]["pres:item"]["pres:description"].element?.text {
                itemDescription = dataDescription
            }
            
            if let dataLabel = datan["ns5:presentation"]["pres:item"]["pres:itemLabel"].element?.text {
                itemlabel = dataLabel
            }
            
            if let dataType = datan["ns5:presentation"]["pres:item"]["pres:type"].element?.text {
                itemType = dataType
            }
            
            if let datathumbnail = datan["ns5:thumbnail"].element?.text {
                thumbnail = datathumbnail
            } else {
                thumbnail = ""
            }
            if let dataTimeLabel = datan["ns5:presentation"]["pres:item"]["pres:context"]["pres:timeLabel"].element?.text{
                timeLabel = dataTimeLabel
            }
            
            var coordniates = datan["ns5:presentation"]["pres:item"]["georss:where"]["gml:Point"]["gml:coordinates"].element!.text!
            
            var splited = coordniates.characters.split{ $0 == "," }.map(String.init)
            long = Double(splited[0])!
            lat = Double(splited[1])!
            
            let item = Item()
            item.itemId = id!
            item.itemLabel = itemlabel!
            item.itemType = itemType!
            item.itemDescription = itemDescription!
            item.thumbnail = thumbnail
            item.lat = lat
            item.lng = long
            item.timeLabel = timeLabel!
            item.discovered = false
            
            //Save item to realm if item has long/lat
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.add(item)
                }
            } catch {
                print("Something went wrong with realm!")
            }
            let realm = try! Realm()
            let items = realm.objects(Item)
            
        }
    }
    
    func clearRealm() {
        //Clear Realm
        do {
            let realm = try Realm()
            try realm.write() {
                realm.deleteAll()
            }
        } catch {
            print("Something went wrong with realm!")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

