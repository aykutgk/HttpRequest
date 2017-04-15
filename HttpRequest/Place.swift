//
//  Place.swift
//  HttpRequest
//
//  Created by Aykut Gedik on 4/14/17.
//
//

import UIKit
import os.log

class Place {
    
    var name: String?
    var photo: UIImage?
    var latitude: Float?
    var longitude: Float?
    var distance: Double?
    
    init?(name: String, photo: UIImage, latitude: Float, longitude: Float, distance: Double) {
        self.name = name
        self.photo = photo
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
    }
    
}
