//
//  SIMChatBaseMessageMapContent.swift
//  SIMChat
//
//  Created by Barry Ma on 2016-06-07.
//  Copyright © 2016 sagesse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SIMChatBaseMessageMapContent: SIMChatMessageBody {

    init(location: CLLocation? = nil, size: CGSize?, locationName: String?) {
        self.size = size!
        self.location = location!
        self.locationName = locationName!
    }
    
    func openMapForLocation(location: CLLocation) {
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = location.coordinate
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.locationName
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
    
    let size: CGSize?
    let location: CLLocation?
    let locationName: String?
}
