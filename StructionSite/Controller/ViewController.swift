//
//  ViewController.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/1/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

//
// ViewController
//    Main View Controller
//    It hosts the Yellow Stone Map and inititates the logic for adding various markers
//

class ViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: - Variables
  var campSitesManager: MarkerManager = MarkerManager()
  var fixedLocationsManager: MarkerManager = MarkerManager()
  var camperManager: CamperManager = CamperManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
          
    camperManager.delegate = self
    
    initializeMap()
    startDownloadingFixedLocationsData()
    startDownloadingCampSitesData()
    startAddingCampers()
    updateTitle()
  }
  
  private func initializeMap() {
    let midCoordinate = CLLocationCoordinate2DMake(Constants.YS_Center_Lat, Constants.YS_Center_Long)
    let regionRadius: CLLocationDistance = 100000
    let coordinateRegion = MKCoordinateRegion(center: midCoordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    mapView.register(MarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
  }
  
  private func startDownloadingFixedLocationsData() {
    fixedLocationsManager.getMarkersData(fileName: Constants.JSON_FILE_FIXED_LOCATIONS) { [weak self] success, errorMessage in
      if success == true {
        self?.updateFixedLocations()
      } else {
        self?.showErrorMessage(error: errorMessage)
      }
    }
  }
  
  private func startAddingCampers() {
    camperManager.startCreatingRandomCampers()
  }
  
  private func startDownloadingCampSitesData() {
    campSitesManager.getMarkersData(fileName: Constants.JSON_FILE_CAMP_SITES) { [weak self] success, errorMessage in
      if success == true {
        self?.updateCampSites()
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
  
  private func updateTitle() {
    self.title = "YellowStone (" + String(campSitesManager.count()) + " Campsites, " + String(camperManager.count()) + " Campers)"
  }
}

//
// extension for MKMapViewDelegate
//

extension ViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let location = view.annotation as? Marker else { return}
    confirmWithUserForStatusUpdate(marker: location)
  }
  
  func confirmWithUserForStatusUpdate(marker: Marker) {
    let alertTitle = (marker.markerStatus == .open) ? "Mark the campsite close" : "Mark the campsite open"
    let alertController = UIAlertController(title: alertTitle, message: "Are you sure?", preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "Yes", style: .default) { (_: UIAlertAction!) in
      if self.campSitesManager.updateMarker(marker: marker) {
        self.mapView.removeAnnotation(marker)
        self.mapView.addAnnotation(marker)
      }
    }
    
    alertController.addAction(OKAction)
    
    let cancelAction = UIAlertAction(title: "No", style: .cancel) { (_: UIAlertAction!) in
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

//
// extension to serve as delegate for CamperManager (method CamperHandler)
//

extension ViewController: CamperHandler {
  func handleCamperAdded (marker: Marker) {
    self.mapView.addAnnotation(marker)
    self.updateTitle()
  }
}
