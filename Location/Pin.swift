//
//  Pin.swift
//  Location
//
//  Created by Dany on 30.10.2021.
//


import Foundation
import MapKit


class Pin: NSObject, Codable {
    let name: String
    let caption: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, description: String, latitude: Double, longitude: Double) {
        self.name = name
        self.caption = description
        self.latitude = latitude
        self.longitude = longitude
    }
}


extension Pin {
    static let pinsKey = "pins"
    
    static func save(pins: [Pin]) {
        let data = try? JSONEncoder().encode(pins)  
        UserDefaults.standard.set(data, forKey: pinsKey)
    }
    
    static func loadPins() -> [Pin]? {
        if let data = UserDefaults.standard.value(forKey: pinsKey) as? Data,
            let pins = try? JSONDecoder().decode([Pin].self, from: data) {
            
            return pins
        }
        return nil
    }
    
}



extension Pin: MKAnnotation {
    
   
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    
    public var title: String? {
        return self.name
    }
    
    public var subtitle: String? {
        return self.caption
    }
}

