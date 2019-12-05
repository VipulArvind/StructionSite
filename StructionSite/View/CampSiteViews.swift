//
//  CampSiteViews.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/5/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import Foundation
import MapKit

class CampSiteViews: MKMarkerAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let campsite = newValue as? Marker else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      markerTintColor = campsite.markerTintColor
//      glyphText = String(artwork.discipline.first!)
        if let imageName = campsite.imageName {
          glyphImage = UIImage(named: imageName)
        } else {
          glyphImage = nil
      }
    }
  }
}

class ArtworkView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let campsite = newValue as? Marker else {return}

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
        size: CGSize(width: 30, height: 30)))
      mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
      rightCalloutAccessoryView = mapsButton
//      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      if let imageName = campsite.imageName {
        image = UIImage(named: imageName)
      } else {
        image = nil
      }

      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = campsite.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }

}
