//
//  GeocodeService.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 26/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//


import Foundation
import CoreLocation

typealias Placemark = CLPlacemark

protocol GeocodeServiceDelegate: class {
    func didLoadPlacemark(_ placemark: Placemark)
}

class GeocodeService {
    weak var delegate: GeocodeServiceDelegate?
    private let geocoder = CLGeocoder()
    
    func reverseGeocode(_ location: CLLocation) {
        let context = (delegate)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?[0] else {
                return
            }
            
            context?.didLoadPlacemark(placemark)
        }
    }
}
