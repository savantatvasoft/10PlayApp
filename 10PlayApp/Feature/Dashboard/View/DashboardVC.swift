//
//  DashboardVC.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit
import MapKit

class DashboardVC: UIViewController {
    @IBOutlet weak var header: Header!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapKit: MKMapView!
    
    let sideMenu = SliderMenu() // Create the instance
    
    
    @IBOutlet weak var missionBtnView: UIButton!
    
    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var flterLabel: UILabel!
    
    @IBOutlet weak var signalLabel: UILabel!
    
    
    @IBOutlet weak var newMissionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        missionLabel.font = AppFont.get(.medium, size: 16)
        
        flterLabel.font = AppFont.get(.medium, size: 16)
        signalLabel.font = AppFont.get(.medium, size: 16)
        newMissionLabel.font = AppFont.get(.medium, size: 16)
        
        header.onLeftTap = { [weak self] in
            print("onTap")
                self?.sideMenu.show(in: self!.view) // Just shows the existing instance
            }
    }

    
    
    // MARK: - Setup Map
    private func setupMap() {
        mapKit.delegate = self
        mapKit.layer.cornerRadius = 12
        mapKit.clipsToBounds = true

        let initialLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        
        let region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        mapKit.setRegion(region, animated: true)
        
        // 3. Add a Point of Interest (Annotation)
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = "10Play Event"
        annotation.subtitle = "Join the cinematic experience"
        mapKit.addAnnotation(annotation)
        
        // 4. Cinematic styling for iOS 16+
        if #available(iOS 16.0, *) {
            let config = MKStandardMapConfiguration(emphasisStyle: .muted)
            config.pointOfInterestFilter = .excludingAll
            mapKit.preferredConfiguration = config
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showValidationPopup()
    }
    
    private func showValidationPopup() {
        
        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else {
            
            return
        }
        
        guard let forgotView = Bundle.main.loadNibNamed("ForgotPasswordPopUp", owner: nil)?.first as? ForgotPasswordPopUp else { return }
        
        forgotView.headerLabel.text = "10Play.io"
        forgotView.headerLabel.textAlignment = .center
        forgotView.headerLabel.font = AppFont.get(.bold, size: 16)
        forgotView.emailLabel.numberOfLines = 0
        forgotView.emailLabel.lineBreakMode = .byWordWrapping
        forgotView.emailLabel.textAlignment = .left
        forgotView.emailLabel.text = "Do you want to enable biometric authentication?"
        forgotView.emailLabel.font = AppFont.get(.regular, size: 14)
        forgotView.emailLabel.addCharacterSpacing(kernValue: 1)
        forgotView.textFieldContainer.isHidden = true
        forgotView.emailTextField.isHidden = true
        
        let popupWidth = self.view.frame.width
        let targetSize = CGSize(width: popupWidth, height: UIView.layoutFittingCompressedSize.height)
        let dynamicSize = forgotView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        forgotView.frame = CGRect(x: 0, y: 0, width: popupWidth, height: dynamicSize.height + 40)
        
        forgotView.entryDirection = "bottom"
        forgotView.exitDirection = "bottom"
        forgotView.layoutIfNeeded()
        
        forgotView.onConfirm = { [weak self] _ in
            // Logic for YES (Oui)
            PreferenceManager.hasAskedBiometric = true
            PreferenceManager.isBiometricEnabled = true
        }
        
        forgotView.show(in: self.view)
    }
    
    @objc private func handleBiometricDecline() {
        PreferenceManager.hasAskedBiometric = true
        PreferenceManager.isBiometricEnabled = false
        // The popup will dismiss itself via its internal cancelPressed logic
    }
}

extension DashboardVC: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "EventMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemBlue // Matches 10PlayApp theme
            annotationView?.glyphImage = UIImage(systemName: "play.fill")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
