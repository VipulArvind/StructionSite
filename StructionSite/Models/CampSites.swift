//
//  CampSitesManager.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/1/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// CampSitesManager
//      Class to implement the singleton for managing the CampSites data
//
//

import UIKit
import MapKit

class Campsite: NSObject, Codable, MKAnnotation {
//struct Campsite: Codable, MKAnnotation {
  
  let title: String?
  let details: String
  let latitude: String
  let longitude: String
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
  }
  
  init(title: String, locationName: String, discipline: String, latitude: String, longitude: String) {
    self.title = title
    self.details = locationName
    self.latitude = latitude
    self.longitude = longitude
    super.init()
  }
  
  var subtitle: String? {
    return details
  }
  
  var markerTintColor: UIColor {
    return .red
  }
  
  var imageName: String? {
    return "CampSite"
  }
}
