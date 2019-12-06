//
//  CampSiteViews.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/5/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import MapKit

class CampSiteView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let tempMarker = newValue as? Marker else {return}
      
      // call button only for campsites
      if tempMarker.type == .campsites {
        canShowCallout = true
        calloutOffset = CGPoint(x: -5, y: 5)
        let campSiteButton = UIButton(frame: CGRect(origin: CGPoint.zero,
          size: CGSize(width: 30, height: 30)))
        if tempMarker.markerStatus == .open {
          campSiteButton.setBackgroundImage(UIImage(named: "close-icon"), for: UIControl.State())
        } else {
          campSiteButton.setBackgroundImage(UIImage(named: "open-icon"), for: UIControl.State())
        }
        rightCalloutAccessoryView = campSiteButton
      }

      if let imageName = tempMarker.imageName {
        image = UIImage(named: imageName)
      } else {
        image = nil
      }

      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      // if campsite then let's add status as well
      if tempMarker.type == .campsites {
        let detailString = (tempMarker.subtitle ?? "") + "\nStatus: " + (tempMarker.statusString ?? "N/A")
        detailLabel.text = detailString
      } else {
        detailLabel.text = tempMarker.subtitle
      }
      
      detailCalloutAccessoryView = detailLabel
    }
  }
}
