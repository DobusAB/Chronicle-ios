//
//  AppDelegate.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AEXML
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
        
        
        //Clear Realm
        do {
            let realm = try Realm()
            try realm.write() {
                realm.deleteAll()
            }
        } catch {
            print("Something went wrong with realm!")
        }
        
        // Override point for customization after application launch.
        guard let
            xmlPath = NSBundle.mainBundle().pathForResource("data1", ofType: "xml"),
            data = NSData(contentsOfFile: xmlPath)
            else { return true}
        
        do {
            let xmlDoc = try AEXMLDocument(xmlData: data)
            var list = [AEXMLElement]()
            var count: Int = 0
            for dog in xmlDoc.root["records"]["record"].all! {
                list.append(dog);
                print(count)
                count++
            }
            
            for record in list {
                let item = Item()
                for rec in record.children {
                    //print(rec.attributes["name"]);
                    if let attr = rec.attributes["name"] {
                        if attr == "itemId" {
                            item.itemId = rec.stringValue
                        }
                        if attr == "itemLabel" {
                            item.itemLabel = rec.stringValue
                        }
                        if attr == "thumbnail" {
                            item.thumbnail = rec.stringValue
                        }
                        if attr == "itemType" {
                            item.itemType = rec.stringValue
                        }
                        if attr == "itemDescription" {
                            item.itemDescription = rec.stringValue
                        }
                        if attr == "lon" {
                            item.lng = rec.stringValue
                        }
                        if attr == "lat" {
                            item.lat = rec.stringValue
                        }
                    }
                }
                //Save item to realm
                do {
                    let realm = try Realm()
                    try realm.write() {
                        realm.add(item)
                    }
                } catch {
                    print("Something went wrong with realm!")
                }
            }
            
        }
        catch {
            print("\(error)")
        }
        
        //Lets see if stored
        let realm = try! Realm()
        let items = realm.objects(Item)
        print(items)
        
        return true
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
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,sourceApplication: sourceApplication, annotation: annotation)
    }

}

