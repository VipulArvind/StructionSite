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

final class MarkerManager: NSObject {
  
  // MARK: - Vars
  var campSitesList: [Marker] = []
  let fileManager: FileManager = FileManager.default
    
  // MARK: - overrides
  override init() {
    super.init()
  }
  
  func getCampSitesData (completion: @escaping APICallback) {
        
    guard let mainUrl = Bundle.main.url(forResource: "CampSites", withExtension: "json") else { return }
            
    do {
      let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      let subUrl = documentDirectory.appendingPathComponent("CampSites.json")
      loadFile(mainPath: mainUrl, subPath: subUrl)
      completion(true, "")
    } catch {
      print(error)
      completion(false, error.localizedDescription)
    }
  }
  
  func loadFile(mainPath: URL, subPath: URL) {
    if fileManager.fileExists(atPath: subPath.path) {
      decodeData(pathName: subPath)
          
      if campSitesList.isEmpty {
        decodeData(pathName: mainPath)
      }
          
    } else {
      decodeData(pathName: mainPath)
    }
  }
  
  func decodeData(pathName: URL) {
    do {
      let jsonData = try Data(contentsOf: pathName)
      let decoder = JSONDecoder()
      campSitesList = try decoder.decode([Marker].self, from: jsonData)
    } catch {}
  }
  
  // MARK: - Public Methods
   
  func count() -> Int {
    return campSitesList.count
  }
   
  func campSite(atIndex: Int) -> Marker? {
    if campSitesList.count > atIndex {
      return campSitesList[atIndex]
    }
    return nil
  }
   
  func allCampSites() -> [Marker] {
    return campSitesList
  }
   
  func first() -> Marker? {
    return campSitesList.first
  }
  
  func resetCampSitesList() {
    campSitesList.removeAll()
  }
}
