//
//  MapViewController.swift
//  Chronicle
//
//  Created by Sebastian Marcusson on 2016-02-27.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import RealmSwift
//import RealmMapView
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        //let location = CLLocationCoordinate2D(latitude: 56.6890642598087, longitude: 12.8339380955437)
        //let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        //mapView.setRegion(region, animated: true)
        
        let realm = try! Realm()
        let items = realm.objects(Item)
        var annotations = [MKPointAnnotation]();
        //print(items)
        
        
        for item in items {
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng)
            annotation.title = item.itemLabel
            self.mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        
        //let annotations = getMapAnnotations()
        mapView.addAnnotations(annotations)
        
        
        var localn = UILocalNotification()
        localn.alertBody = "Hellåå"
        localn.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(localn)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
