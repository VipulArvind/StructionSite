//
//  AddCampSiteVC.swift
//  StructionSite
//
//  Created by Vipul Arvind on 12/7/19.
//  Copyright © 2019 Vipul Arvind. All rights reserved.
//

import UIKit
import MapKit

//
// AddCampSiteVC
//    View Controller for collecting data from user (for adding a new camopsite)
//

//
// protocol to tell the delegation class that 1 new Campsite should be added
//

protocol AddNewCampSiteHandler: class {
  func handleNewCampSiteAddRequested (name: String, details: String, location: CLLocationCoordinate2D)
}

class AddCampSiteVC: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var txtCampSiteName: UITextField!
  @IBOutlet weak var txtCampSiteDetails: UITextField!
  
  // MARK: - Variables
  weak var delegate: AddNewCampSiteHandler?
  var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - IBActions
  @IBAction func okButtonTapped(_ sender: Any) {
    
    guard let name = txtCampSiteName.text else { return }
    guard let details = txtCampSiteDetails.text else { return }
    
    if name.isEmpty {
      showErrorMessage(error: "Campsite name can not be empty")
      return
    }
    
    if details.isEmpty {
      showErrorMessage(error: "Campsite details can not be empty")
      return
    }
    
    delegate?.handleNewCampSiteAddRequested(name: name, details: details, location: location)
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Private methods
  private func showErrorMessage (error: String) {
    let alertController = UIAlertController(title: "Adding a campsite", message:
      error, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
      
    self.present(alertController, animated: true, completion: nil)
  }
}
