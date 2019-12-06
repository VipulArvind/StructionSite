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

enum MarkerType: Int, Codable {
  case fixedLocations = 0
  case campsites
  case campers
  
  func image() -> String {
    switch self {
    case .fixedLocations:
      return "FixedLocations"
    case .campsites:
      return "CampSite"
    case .campers:
      return "Camper"
    }
  }
}

enum MarkerStatus: Int, Codable {
  case open = 0
  case closed
  case NA
  
  func status() -> String {
    switch self {
    case .open:
      return "Open"
    case .closed:
      return "Closed"
    case .NA:
      return "NA"
    }
  }
}

class Marker: NSObject, Codable, MKAnnotation {
  let title: String?
  var details: String
  let latitude: String
  let longitude: String
  let type: MarkerType
  var markerStatus: MarkerStatus
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
  }
  
  init(title: String, locationName: String, discipline: String, latitude: String, longitude: String, type: MarkerType, status: MarkerStatus) {
    self.title = title
    self.details = locationName
    self.latitude = latitude
    self.longitude = longitude
    self.type = type
    self.markerStatus = status
    
    super.init()
  }
  
  var subtitle: String? {
    return details
  }
  
  var markerTintColor: UIColor {
    return .red
  }
  
  var imageName: String? {
    return type.image()
  }
  
  var statusString: String? {
    return markerStatus.status()
  }
}
