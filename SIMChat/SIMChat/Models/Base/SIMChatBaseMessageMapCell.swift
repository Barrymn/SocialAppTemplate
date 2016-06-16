//
//  SIMChatBaseMessageMapCell.swift
//  SIMChat
//
//  Created by Barry Ma on 2016-06-07.
//  Copyright © 2016 sagesse. All rights reserved.
//

import UIKit
//import SnapKit
import MapKit
import CoreLocation

class SIMChatBaseMessageMapCell: SIMChatBaseMessageBubbleCell, MKMapViewDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _mapView.clipsToBounds = true
        _mapView.contentMode = .ScaleAspectFill
        _mapView.translatesAutoresizingMaskIntoConstraints = false
        _mapView.delegate = self
        
        bubbleView.contentView.addSubview(_mapView)
        _mapViewLayout = SIMChatLayout.make(_mapView)
            .top.equ(bubbleView.contentView).top
            .left.equ(bubbleView.contentView).left
            .right.equ(bubbleView.contentView).right
            .bottom.equ(bubbleView.contentView).bottom
            .width.equ(0).priority(751)
            .height.equ(0).priority(751)
            .submit()
    }
    
    override var model: SIMChatMessage? {
        didSet{
            guard let message = model, content = self.content where message != oldValue else {
                return
            }
            if content.size != nil {
                let width = max(content.size!.width, 32)
                let height = max(content.size!.height, 32)
                let scale = min(min(135, width) / width, min(135, height) / height)
                
                _mapViewLayout?.width = width * scale
                _mapViewLayout?.height = height * scale
            }
            
            
            guard superview != nil else {
                return
            }
            
            /// 默认
            isLoaded = false
            let geoCoder = CLGeocoder()
            if content.location != nil {
                geoCoder.reverseGeocodeLocation(content.location!, completionHandler: { placemarks, error in
                    if error != nil {
                        print("Place not found!")
                        return
                    }
                    if let placemarks = placemarks {
                        // Get the first placemark
                        let placemark = placemarks[0]
                        // Add annotation
                        let annotation = MKPointAnnotation()
//                        if let locationName = placemark.addressDictionary!["Name"] as? NSString {
//                            annotation.title = locationName as String
//                        }
                        if let location = placemark.location {
                            annotation.coordinate = location.coordinate
                            // Display the annotation
                            if(self.mapView != nil){
                                var mapRegion = MKCoordinateRegion()
                                mapRegion.center = content.location!.coordinate
                                mapRegion.span = MKCoordinateSpanMake(2, 2)
                                self.mapView!.setRegion(mapRegion, animated: false)
                                self.mapView!.showAnnotations([annotation], animated: false)
                                self.mapView!.zoomEnabled = false
                                self.mapView!.scrollEnabled = false
                                self.mapView!.userInteractionEnabled = false
                            }
                        }
                    }
                })
                isLoaded = true
            }
        }
    }
    
    private var content: SIMChatBaseMessageMapContent? {
        return model?.content as? SIMChatBaseMessageMapContent
    }
    
    var isLoaded: Bool = false
    var mapView: MKMapView? {
        return _mapView
    }
    private var _mapViewLayout: SIMChatLayout?
    private lazy var _mapView: MKMapView! = MKMapView()
    
    
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
            annotationView?.canShowCallout = false
        }
        
        return annotationView
    }
    
}
