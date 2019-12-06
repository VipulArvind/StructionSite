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
  var campSitesManager: MarkerManager = MarkerManager()
  var fixedLocationsManager: MarkerManager = MarkerManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
          
    initializeMap()
    startDownloadingFixedLocationsData()
    startDownloadingCampSitesData()
  }
  
  private func initializeMap() {
    let midCoordinate = CLLocationCoordinate2DMake(Constants.YS_Center_Lat, Constants.YS_Center_Long)
    let regionRadius: CLLocationDistance = 100000
    let coordinateRegion = MKCoordinateRegion(center: midCoordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    mapView.register(CampSiteView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
  }
  
  private func startDownloadingFixedLocationsData() {
    fixedLocationsManager.getMarkersData(fileName: "LocationsInYSPark") { [weak self] success, errorMessage in
      if success == true {
        self?.updateFixedLocations()
                
        print("campSitesManager.count = \(String(describing: self?.campSitesManager.count()))")
        print("Dhakan")
      } else {
        self?.showErrorMessage(error: errorMessage)
      }
    }
  }
  
  private func startDownloadingCampSitesData() {
    campSitesManager.getMarkersData(fileName: "CampSites") { [weak self] success, errorMessage in
      if success == true {
        self?.updateCampSites()
                
        print("campSitesManager.count = \(String(describing: self?.campSitesManager.count()))")
        print("Dhakan")
      } else {
        self?.showErrorMessage(error: errorMessage)
      }
    }
  }
  
  private func showErrorMessage (error: String) {
    let alertController = UIAlertController(title: "Unable to retrieve Vehicle Data", message:
      error, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
      
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func updateCampSites() {
    mapView.addAnnotations(campSitesManager.markersList)
  }
  
  private func updateFixedLocations() {
    mapView.addAnnotations(fixedLocationsManager.markersList)
  }
}

extension ViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    //guard let location = view.annotation as! Marker else { return }
    let location = view.annotation as! Marker
    confirmWithUserForStatusUpdate(marker: location)
  }
  
  func confirmWithUserForStatusUpdate(marker: Marker) {
    let alertController = UIAlertController(title: "Alert title", message: "Message to display", preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
      print("Yes button tapped")
      
      if self.campSitesManager.updateMarker(marker: marker) {
        self.mapView.removeAnnotation(marker)
        self.mapView.addAnnotation(marker)
      }
    }
    
    alertController.addAction(OKAction)
    
    let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action: UIAlertAction!) in
        print("No button tapped")
    }
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState,
               fromOldState oldState: MKAnnotationView.DragState) {
    
    print("in")
  
   /* if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }*/
  }
    
}
