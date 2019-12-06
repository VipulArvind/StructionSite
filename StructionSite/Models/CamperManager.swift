//
//  CamperManager.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/6/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// CamperManager
//      Class for managing the Marker data
//
//

import UIKit
import MapKit

protocol CamperHandler: class {
  func handleCamperAdded (marker: Marker)
}

final class CamperManager: NSObject {
  
  // MARK: - Vars
  var markersList: [Marker] = []
  weak var delegate: CamperHandler?
  static let randomCamperDescriptions = ["Jay's American Coach", "Steffi's Entegra", "Queen Fleetwood RV", "Tiny Holiday Rambler", "Jayco Camper"]
  static let randomCamperPhoneNumber = ["703-121-1111", "512-242-2222", "916-363-3333", "403-484-4444", "202-505-5555"]
      
  // MARK: - overrides
  override init() {
    super.init()
  }
  
  func startCreatingRandomCampers () {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      self.addRandomCamper()

      if self.count() >= Constants.MAX_CAMPERS {
            timer.invalidate()
        }
    }
  }
  
  func addRandomCamper() {
    let iIndex = getIndexForNextCamper()
    let camperName = self.generateCamperName(index: iIndex)
    let camperDetails = self.generateCamperDetails(index: iIndex)
    let location = generateRandomCoordinates(min: 20000, max: 20000)
    let marker = Marker(title: camperName,
                        details: CamperManager.randomCamperDescriptions[iIndex],
                        latitude: String(location.latitude),
                        longitude: String(location.longitude),
                        type: .campers,
                        phoneNumber: CamperManager.randomCamperPhoneNumber[iIndex],
                        status: .NA)
    
    markersList.append(marker)
    delegate?.handleCamperAdded(marker: marker)
  }
  
  func generateCamperName(index: Int) -> String {
    return "Camper " + String(index)
  }
  
  func generateCamperDetails(index: Int) -> String {
    return CamperManager.randomCamperDescriptions[index] + "\nPhone: " + CamperManager.randomCamperPhoneNumber[index]
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
