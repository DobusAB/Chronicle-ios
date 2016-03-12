//
//  MapViewController.swift
//  Chronicle
//
//  Created by Sebastian Marcusson on 2016-02-27.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let treasureTransitionmanager = TreasureTransitionManager()
    var locationManager = CLLocationManager()
    var regionsToMonitor = [CLCircularRegion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
        if mapView.subviews.count > 0 {
            //mapView.subviews.first?.subviews.first?.alpha = 0.0
        }
        //mapView.setRegion(region, animated: true)
        
        let realm = try! Realm()
        let items = realm.objects(Item)
        var annotations = [MKPointAnnotation]()
        let user = realm.objects(User).first
        
        for item in items {
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng)
            annotation.title = item.itemLabel
            annotation.imageName = "treasure-pin"
            annotations.append(annotation)
            addRadiusCircle(CLLocation(latitude: item.lat, longitude: item.lng))
            //self.mapView.addAnnotation(annotation)
        }
        
        //let annotations = getMapAnnotations()
        mapView.addAnnotations(annotations)
        
        
        //let region = CLCircularRegion(center: annotation.coordinate, radius: 1000, identifier: item)
        //CLCircularRegion(center: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, identifier: <#T##String#>)
        
        
        /*var localn = UILocalNotification()
        localn.alertBody = "Hellåå"
        localn.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(localn)*/

    }

    func initLocationManager() {
        //Ask for permission to read user location
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    @IBAction func openTreasureModal(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TreasureViewController") as! TreasureViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = treasureTransitionmanager
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: 50 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named: cpa.imageName)
        
        return anView
    }
    
    // MARK: LocationManager methods
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
        print(self.mapView.userLocationVisible)
        print(newLocation.coordinate.latitude)
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
