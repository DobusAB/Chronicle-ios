//
//  AppDelegate.swift
//  Chronicle
//
//  Created by Albin Martinsson on 2016-02-07.
//  Copyright © 2016 Dobus. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SWXMLHash
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var regionsToMonitor = [CLCircularRegion]()

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
        
        //Ask for permission to read user location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
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
        
        let xmlPath = NSBundle.mainBundle().pathForResource("data1", ofType: "xml")
        
        let data = NSData(contentsOfFile: xmlPath!)
        let xml = SWXMLHash.lazy(data!)
        let xmlItems = xml["result"]["records"]["record"]
        var lat: Double = 0.0;
        var long: Double = 0.0;
        var itemlabel: String? = "";
        var itemDescription: String? = "";
        var thumbnail: String? = "";
        var itemType: String? = "";
        var id : String? = "";
        var timeLabel: String? = "";
        
        for items in xmlItems {
            
            /*for description in items["rdf:RDF"]["rdf:Description"] {
                print(description["ns5:presentation"]["pres:item"]["pres:id"].element?.text)
            }*/
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
            }
            if let dataTimeLabel = datan["ns5:presentation"]["pres:item"]["pres:context"]["pres:timeLabel"].element?.text{
                timeLabel = dataTimeLabel
                //print(dataTimeLabel)
                
            }
            
            
            var coordniates = datan["ns5:presentation"]["pres:item"]["georss:where"]["gml:Point"]["gml:coordinates"].element!.text!
            
            //var coordinatesArr = split(coordniates) {$0 == ","}
            var splited = coordniates.characters.split{ $0 == "," }.map(String.init)
            
            long = Double(splited[0])!
        
        
            lat = Double(splited[1])!
            
            
            let item = Item()
            
            item.itemId = id!
            item.itemLabel = itemlabel!
            item.itemType = itemType!
            item.itemDescription = itemDescription!
            item.thumbnail = thumbnail!
            item.lat = lat
            item.lng = long
            item.timeLabel = timeLabel!
            
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
            print(items)
            
            
        }
        
        // Override point for customization after application launch.
        /*guard let
            xmlPath = NSBundle.mainBundle().pathForResource("data1", ofType: "xml"),
            data = NSData(contentsOfFile: xmlPath)
            else { return true}
        
        do {
            let xmlDoc = try AEXMLDocument(xmlData: data)
            var records = [AEXMLElement]()
            var count: Int = 0
            //print(xmlDoc.xmlString)
            print("Some locations")
            
            
            
            for item in xmlDoc.root["records"]["record"].all! {
                records.append(item);
                //print(count)
                //print(item);
                count++
            }
            
            for record in records {
                let item = Item()
                //print(record.children)
                for rec in record.children {
                    //print(rec.stringValue)
                }
            }
            
            /*for record in list {
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
                            item.lng = rec.doubleValue
                        }
                        if attr == "lat" {
                            item.lat = rec.doubleValue
                        }
                    }
                }
                //Let see if item has long/lat
                if item.lng == 0.0 {
                    //print("You do not belong in this app")
                } else {
                    //Save item to realm if item has long/lat
                    do {
                        let realm = try Realm()
                        try realm.write() {
                            realm.add(item)
                        }
                    } catch {
                        print("Something went wrong with realm!")
                    }
                }
            }*/
            
        }
        catch {
            print("\(error)")
        }*/
        
        return true
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Monitor started")
        print(region)
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {
            print("We are at region")
        } else {
            print("We are outside of region")
        }
        print(state.rawValue)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION")
        print(region.identifier)
        sendNotification(region)
    }
    
    func sendNotification(region: CLRegion) {
        do {
            let realm = try Realm()
            let item = realm.objects(Item).filter("itemId == '\(region.identifier)'")[0]
            var localn = UILocalNotification()
            localn.alertBody = "Du hittade en skattkista: \(item.itemLabel)"
            localn.soundName = UILocalNotificationDefaultSoundName;
            UIApplication.sharedApplication().presentLocalNotificationNow(localn)
        } catch {
            print("Something went wrong with realm!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("DID EXIT REGION")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("newLocation")
        print(newLocation.coordinate.latitude)
        for region in regionsToMonitor {
            locationManager.stopMonitoringForRegion(region)
        }
        regionsToMonitor.removeAll()
        
        let realm = try! Realm()
        let items = realm.objects(Item)
        for item in items {
            let haversineDiff = haversine(newLocation.coordinate.latitude, lon1: newLocation.coordinate.longitude, lat2: item.lat, lon2: item.lng)
            do {
                let realm = try Realm()
                try realm.write() {
                    item.haversine = haversineDiff
                    realm.add(item, update: true)
                }
            } catch {
                print("Something went wrong with realm!")
            }
        }
        
        let itemSortedByHaversine = items.sort({$0.haversine < $1.haversine})
        for (index, itemSorted) in itemSortedByHaversine.enumerate() {
            if index < 20 {
                let tempRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: itemSorted.lat, longitude: itemSorted.lng), radius: 50, identifier: itemSorted.itemId)
                regionsToMonitor.append(tempRegion)
            }
        }
        
        for region in regionsToMonitor {
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let lat1rad = lat1 * M_PI/180
        let lon1rad = lon1 * M_PI/180
        let lat2rad = lat2 * M_PI/180
        let lon2rad = lon2 * M_PI/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 6372.8
        
        return R * c
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
    
/*    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
    }*/

}

