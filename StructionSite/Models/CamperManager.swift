//
//  CamperManager.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// CamperManager
//    Class for managing Campers
//    This is kept separate from Campsites + FixedLocations since we are suppose to generate them randomly (as oppose to reading from file(s))
//    method startCreatingRandomCampers creates 1 camper every 5 seonds until the max limit (5) is reached
//

import UIKit
import MapKit

//
// protocol to tell the delegation class that 1 new camper has been added

protocol CamperHandler: class {
  func handleCamperAdded (marker: Marker)
}

final class CamperManager: NSObject {
  
  // MARK: - Class level static data
  static let camperNames = ["Camper 1", "Camper 2", "Camper 3", "Camper 4", "Camper 5"]
  static let camperDescriptions = ["Jay's American Coach", "Steffi's Entegra", "Queen Fleetwood RV", "Tiny Holiday Rambler", "Jayco Camper"]
  static let camperPhoneNumbers = ["703-121-1111", "512-242-2222", "916-363-3333", "403-484-4444", "202-505-5555"]
  
  // MARK: - Vars
  var markersList: [Marker] = []
  weak var delegate: CamperHandler?
  
  // MARK: - overrides
  override init() {
    super.init()
  }
  
  func startCreatingRandomCampers () {
    Timer.scheduledTimer(withTimeInterval: Constants.TIME_BETWEEN_CREATING_EACH_CAMPER, repeats: true) { timer in
      self.addRandomCamper()

      if self.count() >= Constants.MAX_CAMPERS {
        timer.invalidate()
      }
    }
  }
  
  func addRandomCamper() {
    let iIndex = getIndexForNextCamper()
    
    let location = generateRandomCoordinates(min: Constants.MIN_DIST_FOR_CAMPER_FROM_CENTER,
                                             max: Constants.MAX_DIST_FOR_CAMPER_FROM_CENTER)
    let marker = Marker(title: CamperManager.camperNames[iIndex],
                        details: CamperManager.camperDescriptions[iIndex],
                        latitude: String(location.latitude),
                        longitude: String(location.longitude),
                        type: .campers,
                        phoneNumber: CamperManager.camperPhoneNumbers[iIndex],
                        status: .NA)
    
    markersList.append(marker)
    delegate?.handleCamperAdded(marker: marker)
  }
  
  // random coordinates generator
  // taken from https://stackoverflow.com/questions/38326875/how-to-place-annotations-randomly-in-mapkit-swift
  // input : Map center
  // input : min and max distance (meters) from center
  // output : random location
  
  func generateRandomCoordinates(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {
    //Get the Current Location's longitude and latitude
    let currentLong = Constants.YS_Center_Long
    let currentLat = Constants.YS_Center_Lat

    //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
    let meterCord = 0.00900900900901 / 1000

    //Generate random Meters between the maximum and minimum Meters
    let randomMeters = UInt(arc4random_uniform(max) + min)

    //then Generating Random numbers for different Methods
    let randomPM = arc4random_uniform(6)

    //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
    let metersCordN = meterCord * Double(randomMeters)

    //here we generate the last Coordinates
    if randomPM == 0 {
        return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
    } else if randomPM == 1 {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
    } else if randomPM == 2 {
        return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
    } else if randomPM == 3 {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
    } else if randomPM == 4 {
        return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
    } else {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
    }
  }
  
  func getIndexForNextCamper() -> Int {
    return self.count()
  }
    
  // MARK: - Public Methods
   
  func count() -> Int {
    return markersList.count
  }
}
