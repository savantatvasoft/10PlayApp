//
//  DashboardVC.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit
import MapKit

class DashboardVC: BaseViewController {
    
    @IBOutlet weak var header: Header!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var missionBtnView: UIButton!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var flterLabel: UILabel!
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var newMissionLabel: UILabel!
    @IBOutlet weak var listOfFilterVIew: UIStackView!
    @IBOutlet weak var missionContainer: UIStackView!
    @IBOutlet weak var filterMapContainer: UIStackView!
    @IBOutlet weak var newMIssionContainer: UIStackView!
    @IBOutlet weak var signalsConatiner: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        attachHeader(header)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showValidationPopup()
    }
    
    
    @IBAction func onPressToggle(_ sender: UIButton) {
        if listOfFilterVIew.isHidden {
            showFilterView()
            rotateButton(sender, expanded: true)
        } else {
            hideFilterView()
            rotateButton(sender, expanded: false)
        }
    }
    
    
    @IBAction func onPressFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "navigateToFilter", sender: self)
    }
    
}



extension DashboardVC {
    
    func setup() {
        
        setupMap()
        prepareFilterView()
        
        let labels = [missionLabel, flterLabel, signalLabel, newMissionLabel]
        
        labels.forEach {
            $0?.font = AppFont.get(.extraBold, size: 14)
        }
        
    }
    
    func rotateButton(_ button: UIButton, expanded: Bool) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                button.transform = expanded
                    ? CGAffineTransform(rotationAngle: .pi / 4)
                    : .identity
            }
        )
    }
    
    func prepareFilterView() {
        listOfFilterVIew.isHidden = false
        listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
        listOfFilterVIew.alpha = 0
        listOfFilterVIew.arrangedSubviews.forEach {
            $0.transform = CGAffineTransform(translationX: 200, y: 0)
            $0.alpha = 0
        }
    }
    
    func hideFilterView() {

        for (index, view) in listOfFilterVIew.arrangedSubviews.enumerated() {
            UIView.animate(
                withDuration: 0.2,
                delay: 0.03 * Double(index),
                options: [.curveEaseIn],
                animations: {
                    view.transform = CGAffineTransform(translationX: 200, y: 0)
                    view.alpha = 0
                }
            )
        }
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.1,
            options: [.curveEaseIn],
            animations: {
                self.listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
                self.listOfFilterVIew.alpha = 0
            },
            completion: { _ in
                self.listOfFilterVIew.isHidden = true
            }
        )
    }
    
    func showFilterView() {
        listOfFilterVIew.isHidden = false
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                self.listOfFilterVIew.transform = .identity
                self.listOfFilterVIew.alpha = 1
            }
        )
        
        for (index, view) in listOfFilterVIew.arrangedSubviews.enumerated() {
            UIView.animate(
                withDuration: 0.4,
                delay: 0.05 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut],
                animations: {
                    view.transform = .identity
                    view.alpha = 1
                }
            )
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
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = "10Play Event"
        annotation.subtitle = "Join the cinematic experience"
        mapKit.addAnnotation(annotation)
        
        if #available(iOS 16.0, *) {
            let config = MKStandardMapConfiguration(emphasisStyle: .muted)
            config.pointOfInterestFilter = .excludingAll
            mapKit.preferredConfiguration = config
        }
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
            PreferenceManager.hasAskedBiometric = true
            PreferenceManager.isBiometricEnabled = true
        }
        
        forgotView.show(in: self.view)
    }
    
    @objc private func handleBiometricDecline() {
        PreferenceManager.hasAskedBiometric = true
        PreferenceManager.isBiometricEnabled = false
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
