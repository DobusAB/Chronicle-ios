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

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let treasureTransitionmanager = TreasureTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //let location = CLLocationCoordinate2D(latitude: 56.6890642598087, longitude: 12.8339380955437)
        //let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        //mapView.setRegion(region, animated: true)
        
        let realm = try! Realm()
        let items = realm.objects(Item)
        var annotations = [MKPointAnnotation]();
        let user = realm.objects(User).first
        //print(items)
        
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 56.6890642598087, longitude: 12.8339380955437)
        annotation.title = "heheh"
        //annotation.imageName = user?.image as! String
        self.mapView.addAnnotation(annotation)
        
        /*for item in items {
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 56.6890642598087, longitude: 12.8339380955437)
            annotation.title = item.itemLabel
            annotation.imageName = user?.image as! String
            self.mapView.addAnnotation(annotation)
            annotations.append(annotation)
            addRadiusCircle(CLLocation(latitude: item.lat, longitude: item.lng))
        }*/
        
        //let annotations = getMapAnnotations()
        mapView.addAnnotations(annotations)
        
        
       // let region = CLCircularRegion(center: annotation.coordinate, radius: 1000, identifier: item)
        //CLCircularRegion(center: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, identifier: <#T##String#>)
        
        
        /*var localn = UILocalNotification()
        localn.alertBody = "Hellåå"
        localn.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(localn)*/

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
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("Should render")
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
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named: "earth")
        
        return anView
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
