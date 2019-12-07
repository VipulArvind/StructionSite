//
//  MarkerManager.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/1/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

//
// MarkerManager
//    Common Class for managing Campsites (read from CampSites.json) &
//    Fixedlocations (e.g. Mammoth Hot Springs)  (read from LocationsInYSPark.json)
//
//


import UIKit

final class MarkerManager: NSObject {
  
  // MARK: - Vars
  var markersList: [Marker] = []
  let fileManager: FileManager = FileManager.default
  var fileName = ""
    
  // MARK: - overrides
  override init() {
    super.init()
  }
  
  func getMarkersData (fileName: String, completion: @escaping APICallback) {
    self.fileName = fileName
    guard let mainUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else { return }
            
    do {
      let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      let fileURL = documentDirectory.appendingPathComponent(fileName + ".json")
      loadFile(mainPath: mainUrl, subPath: fileURL)
      completion(true, "")
    } catch {
      print(error)
      completion(false, error.localizedDescription)
    }
  }
  
  func loadFile(mainPath: URL, subPath: URL) {
    if fileManager.fileExists(atPath: subPath.path) {
      decodeData(pathName: subPath)
          
      if markersList.isEmpty {
        decodeData(pathName: mainPath)
      }
          
    } else {
      decodeData(pathName: mainPath)
    }
  }
  
  private func decodeData(pathName: URL) {
    do {
      let jsonData = try Data(contentsOf: pathName)
      let decoder = JSONDecoder()
      markersList = try decoder.decode([Marker].self, from: jsonData)
    } catch {}
  }
  
  func updateMarker(marker: Marker) -> Bool {
    if let index = markersList.firstIndex(of: marker) {
      if markersList[index].markerStatus == .open {
        markersList[index].markerStatus = .closed
      } else {
          markersList[index].markerStatus = .open
      }
      
      do {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(fileName + ".json")
        return writeToFile(location: fileURL)
      } catch {
        print(error)
      }
    }
    return false
  }
  
  func writeToFile(location: URL) -> Bool {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let JsonData = try encoder.encode(markersList)
      try JsonData.write(to: location)
      return true
    } catch {}
    
    return false
  }
  
  func addMarker(marker: Marker) -> Bool {
    markersList.append(marker)
    
    do {
      let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      let fileURL = documentDirectory.appendingPathComponent(fileName + ".json")
      return writeToFile(location: fileURL)
    } catch {
      print(error)
    }
    
    return false
  }
  // MARK: - Public Methods
   
  func count() -> Int {
    return markersList.count
  }
}
