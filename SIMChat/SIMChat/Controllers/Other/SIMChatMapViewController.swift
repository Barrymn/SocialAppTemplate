//
//  SIMChatMapViewController.swift
//  SIMChat
//
//  Created by Barry Ma on 2016-05-25.
//  Copyright © 2016 sagesse. All rights reserved.
//

import UIKit
//import SnapKit
import MapKit
import CoreLocation

public protocol SIMChatMapViewControllerDelegate: class {
    func shareButtonPressed(locationShared: CLLocation, locationNameShared: String)
}

class SIMChatMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    private let mapView: MKMapView! = MKMapView()
    private let locationManager = CLLocationManager()
    private var resultSearchController:UISearchController? = nil
    private var annotation:MKAnnotation!
    private var curLocation: CLLocation!
    private var locationShared: CLLocation?
    private var locationNameShared: String?
    


    //MARK: - Map View Delegate Methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? =
            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let rightButton = UIButton(frame: CGRectMake(0, 0, 53, 53))
        rightButton.backgroundColor = UIColor.blueColor()
        rightButton.setTitle("Share", forState: .Normal)
        rightButton.addTarget(self, action: #selector(shareLocation), forControlEvents: .TouchUpInside)
        annotationView?.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    //MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.curLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if curLocation != nil {
                let geoCoder = CLGeocoder()
                //self.locationManager.stopUpdatingLocation()
                geoCoder.reverseGeocodeLocation(curLocation, completionHandler: { (placemarks, error) -> Void in
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    if let placemarks = placemarks {
                        // Get the first placemark
                        let placemark = placemarks[0]
                        // Add annotation
                        let annotation = MKPointAnnotation()
                        
                        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                            annotation.title = locationName as String
                            self.locationNameShared = locationName as String
                        }
                        
                        if let location = placemark.location {
                            annotation.coordinate = location.coordinate
                            self.locationShared = location
                            // Display the annotation
                            self.mapView.showAnnotations([annotation], animated: true)
                            self.mapView.selectAnnotation(annotation, animated: true)
                        }
                    }
                })
            }
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
            
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    func cancelLocation() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    weak var delegate: SIMChatMapViewControllerDelegate?
    
    func shareLocation(){
        if locationShared != nil && locationNameShared != nil {
            delegate?.shareButtonPressed(self.locationShared!, locationNameShared: locationNameShared!)
        }
        else{
            print("No location found!")
        }
        self.cancelLocation()
    }
    
    func searchLocation() {
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController!.hidesNavigationBarDuringPresentation = false
        resultSearchController!.searchBar.delegate = self
        resultSearchController?.searchBar.placeholder = "Search for places"
        presentViewController(resultSearchController!, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        let geoCoder = CLGeocoder()
        
        if searchBar.text != nil {
            geoCoder.geocodeAddressString(searchBar.text!, completionHandler: { placemarks, error in
                if error != nil {
                    let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                if let placemarks = placemarks {
                    // Get the first placemark
                    let placemark = placemarks[0]
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    if let locationName = placemark.addressDictionary!["Name"] as? NSString {
                        annotation.title = locationName as String
                        self.locationNameShared = locationName as String
                    }
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        self.locationShared = location
                        // Display the annotation
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)
                    }
                }
            })
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Current Location"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(SIMChatMapViewController.searchLocation))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(SIMChatMapViewController.cancelLocation))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.navigationBar.barTintColor = UIColor.blueColor()
        
        resultSearchController = UISearchController()
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = false
        
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 10.0
        self.mapView.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
//        mapView.snp_makeConstraints{
//            (make) -> Void in
//            make.top.equalTo(self.view)
//            make.left.equalTo(self.view)
//            make.size.equalTo(self.view)
//        }
        self.view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0))
    }


}
