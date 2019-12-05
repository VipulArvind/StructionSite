//
//  ViewController.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/1/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

  // MARK: - Outlets
  
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: - Variables
  var park = Park(filename: "YellowStone")
  var campSitesManager: CampSitesManager = CampSitesManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    //let latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude
      
    // Think of a span as a tv size, measure from one corner to another
    //let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
    //let region = MKCoordinateRegionMake(park.midCoordinate, span)
    
    let regionRadius: CLLocationDistance = 30000
    let coordinateRegion = MKCoordinateRegion(center: park.midCoordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    addBoundary()
    mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    startDownloadingData()
    
  }
  
  func addBoundary() {
    mapView.addOverlay(MKPolygon(coordinates: park.boundary, count: park.boundary.count))
  }
  
  private func startDownloadingData() {
    campSitesManager.getCampSitesData { [weak self] success, errorMessage in
      if success == true {
        //self?.collectionView.reloadData()
        self?.updateCampSites()
                
        print("campSitesManager.count = \(String(describing: self?.campSitesManager.count()))")
        print("Dhakkan")
      } else {
        self?.showErrorMessage(error: errorMessage)
      }
      //self?.collectionView.refreshControl?.endRefreshing()
    }
  }
    
  func showErrorMessage (error: String) {
    let alertController = UIAlertController(title: "Unable to retrieve Vehicle Data", message:
      error, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
      
    self.present(alertController, animated: true, completion: nil)
  }
  
  func updateCampSites() {
    mapView.addAnnotations(campSitesManager.campSitesList)
  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
    if overlay is MKPolyline {
      let lineView = MKPolylineRenderer(overlay: overlay)
      lineView.strokeColor = UIColor.green
      return lineView
    } else if overlay is MKPolygon {
      let polygonView = MKPolygonRenderer(overlay: overlay)
      polygonView.strokeColor = UIColor.magenta
      return polygonView
    }
      
    return MKOverlayRenderer()
  }
}
