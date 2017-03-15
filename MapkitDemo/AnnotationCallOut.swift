//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/16/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import MapKit

class AnnotationCallOut: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var address: String!
    var image: UIImage!
    var iTag: Int!
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
