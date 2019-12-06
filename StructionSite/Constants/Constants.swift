//
//  Constants.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/1/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import UIKit

//
// Constants
//    To keep all the constants at 1 place
//    Easier to change if we decide to go with some other font/color etc. later on
//

typealias APICallback = (_ success: Bool, _ errorMessage: String) -> Void
typealias DataMgrCallback = (_ result: Data?, _ errorMessage: String) -> Void

struct Constants {    
    
  static let YS_Center_Lat: Double = 44.4280
  static let YS_Center_Long: Double = -110.4885
  static let MAX_CAMPERS = 5
  static let TIME_BETWEEN_CREATING_EACH_CAMPER: TimeInterval = 5
  static let JSON_FILE_FIXED_LOCATIONS = "LocationsInYSPark"
  static let JSON_FILE_CAMP_SITES = "CampSites"
  static let MIN_DIST_FOR_CAMPER_FROM_CENTER: UInt32 = 10000
  static let MAX_DIST_FOR_CAMPER_FROM_CENTER: UInt32 = 25000
  
  // MARK: - Colors
  static let blackColor = UIColor.black
  static let whiteColor = UIColor.white
  static let YSThemeColor = UIColor(red: 214.0/255.0, green: 169.0/255.0, blue: 10.0/255.0, alpha: 1.0)
  
  // MARK: - Fonts
  static let YS_FONT_SIZE_SMALL: CGFloat = 12.0
  static let systemFontSize18 = UIFont.systemFont(ofSize: 18.0)
  static let systemFontBoldSize18 = UIFont.boldSystemFont(ofSize: 18.0)
}
