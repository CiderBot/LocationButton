//
//  Place.swift
//  LocationButton
//
//  Created by Steven Yung on 10/30/23.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        // note that this works for US addresses, not sure about anything else
        cityAndState = placemark.locality ?? "" // this should be city
        if let state = placemark.administrativeArea { // this should be state
            // if state is empty, cityAndState stays the same, otherwise:
            // show either state or city, state depending which fields are not empty
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? ""   // in the US, this is usually the street number
        if let street = placemark.thoroughfare {    // in the US, this is usually the street name
            // filling in the street address similar to city state info
            address = address.isEmpty ? street : "\(address) \(street)"
        }
        
        // now combine everything together, also trim any characters in the current address field
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // no address, then just city and state info
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        
        return address
    }
}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
}
