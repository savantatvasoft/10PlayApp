////
////  DashboardVC.swift
////  10PlayApp
////
////  Created by savan soni on 31/03/26.
////
//
//
//import UIKit
//import MapKit
//
//class DashboardVC: BaseViewController {
//    
//    // MARK: - Outlets
//    @IBOutlet weak var header: Header!
//    
//    @IBOutlet weak var infoPopUpView: UIView!
//    
//    @IBOutlet weak var infoPopupTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var mapKit: MKMapView!
//    @IBOutlet weak var missionBtnView: UIButton!
//    @IBOutlet weak var missionLabel: UILabel!
//    @IBOutlet weak var flterLabel: UILabel!
//    @IBOutlet weak var signalLabel: UILabel!
//    @IBOutlet weak var newMissionLabel: UILabel!
//    @IBOutlet weak var listOfFilterVIew: UIStackView!
//    @IBOutlet weak var missionContainer: UIStackView!
//    @IBOutlet weak var routeLabel: UILabel!
//    @IBOutlet weak var route: UIStackView!
//    @IBOutlet weak var filterMapContainer: UIStackView!
//    @IBOutlet weak var newMIssionContainer: UIStackView!
//    @IBOutlet weak var signalsConatiner: UIStackView!
//    @IBOutlet weak var plusImage: UIImageView!
//    
//    private var sheetDelegate: BottomSheetTransitionDelegate?
//    private var isFilterExpanded = false
//    
//    private var isPopupVisible = false
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//        attachHeader(header)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        showValidationPopup()
//    }
//    
//    // MARK: - IBActions
//    @IBAction func onPressFilter(_ sender: Any) {
//        performSegue(withIdentifier: NavigationKeys.filter.rawValue, sender: self)
//    }
//    
//    @IBAction func onPressFilterMap(_ sender: Any) {
//        openFilterMap()
//    }
//    
//    @IBAction func onPressSignals(_ sender: Any) {
//        performSegue(withIdentifier: NavigationKeys.signals.rawValue, sender: self)
//    }
//    
//    private func toggleInfoPopup() {
//        isPopupVisible.toggle()
//
//        infoPopupTopConstraint.constant = isPopupVisible ? 110 : -infoPopUpView.frame.height
//
//        UIView.animate(
//            withDuration: 0.35,
//            delay: 0,
//            usingSpringWithDamping: 0.88,
//            initialSpringVelocity: 0.4,
//            options: [.curveEaseInOut]
//        ) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    override func onHeaderRightTap() {
//        toggleInfoPopup()
//    }
//}
//
//// MARK: - Setup
//extension DashboardVC {
//    
//    func setup() {
//        setupMap()
//        setupLabels()
//        prepareFilterView()
//        handleTapGestures()
//    }
//    
//    private func setupLabels() {
//        [missionLabel, flterLabel, signalLabel, newMissionLabel, routeLabel].forEach {
//            $0?.font = AppFont.get(.bold, size: 14)
//        }
//    }
//    
//    private func handleTapGestures() {
//        plusImage.isUserInteractionEnabled = true
//        plusImage.addTapGesture(target: self, action: #selector(onPlusTapped))
//    }
//    
//    @objc private func onPlusTapped() {
//        isFilterExpanded ? hideFilterView() : showFilterView()
//        isFilterExpanded.toggle()
//        rotatePlusImage(expanded: isFilterExpanded)
//    }
//    
//    private func rotatePlusImage(expanded: Bool) {
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 0.7,
//            initialSpringVelocity: 0.5,
//            options: [.curveEaseInOut]
//        ) {
//            self.plusImage.transform = expanded
//                ? CGAffineTransform(rotationAngle: .pi / 4)
//                : .identity
//        }
//    }
//    
//    func openFilterMap() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let filterMapVC = storyboard.instantiateViewController(withIdentifier: NavigationKeys.filterMap.rawValue)
//        
//        let delegate = BottomSheetTransitionDelegate(height: 320)
//        sheetDelegate = delegate
//        filterMapVC.modalPresentationStyle = .custom
//        filterMapVC.transitioningDelegate = delegate
//        present(filterMapVC, animated: true)
//    }
//}
//
//// MARK: - Filter Animation
//extension DashboardVC {
//    
//    func prepareFilterView() {
//        listOfFilterVIew.isHidden = false
//        listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
//        listOfFilterVIew.alpha = 0
//        listOfFilterVIew.arrangedSubviews.forEach {
//            $0.transform = CGAffineTransform(translationX: 200, y: 0)
//            $0.alpha = 0
//        }
//    }
//    
//    func hideFilterView() {
//        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
//            UIView.animate(
//                withDuration: 0.2,
//                delay: 0.03 * Double(index),
//                options: [.curveEaseIn]
//            ) {
//                view.transform = CGAffineTransform(translationX: 200, y: 0)
//                view.alpha = 0
//            }
//        }
//        
//        UIView.animate(
//            withDuration: 0.25,
//            delay: 0.1,
//            options: [.curveEaseIn],
//            animations: {
//                self.listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
//                self.listOfFilterVIew.alpha = 0
//            },
//            completion: { _ in
//                self.listOfFilterVIew.isHidden = true
//            }
//        )
//    }
//    
//    func showFilterView() {
//        listOfFilterVIew.isHidden = false
//        UIView.animate(
//            withDuration: 0.35,
//            delay: 0,
//            usingSpringWithDamping: 0.85,
//            initialSpringVelocity: 0.5,
//            options: [.curveEaseOut]
//        ) {
//            self.listOfFilterVIew.transform = .identity
//            self.listOfFilterVIew.alpha = 1
//        }
//        
//        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
//            UIView.animate(
//                withDuration: 0.4,
//                delay: 0.05 * Double(index),
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.5,
//                options: [.curveEaseOut]
//            ) {
//                view.transform = .identity
//                view.alpha = 1
//            }
//        }
//    }
//}
//
//// MARK: - Popup
//extension DashboardVC {
//    
//    private func showValidationPopup() {
//        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else { return }
//        
//        ForgotPasswordPopUp.show(
//            in: self.view,
//            message: "Do you want to enable biometric authentication?",
//            onConfirm: { [weak self] _ in
//                PreferenceManager.hasAskedBiometric = true
//                PreferenceManager.isBiometricEnabled = true
//            },
//            onCancel: { [weak self] in
//                PreferenceManager.hasAskedBiometric = true
//                PreferenceManager.isBiometricEnabled = false
//            }
//        )
//    }
//}
//
//// MARK: - Map
//extension DashboardVC: MKMapViewDelegate {
//    
//    private func setupMap() {
//        mapKit.delegate = self
//        mapKit.layer.cornerRadius = 12
//        mapKit.clipsToBounds = true
//        
//        let initialLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
//        let region = MKCoordinateRegion(
//            center: initialLocation,
//            latitudinalMeters: 1000,
//            longitudinalMeters: 1000
//        )
//        mapKit.setRegion(region, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = initialLocation
//        annotation.title = "10Play Event"
//        annotation.subtitle = "Join the cinematic experience"
//        mapKit.addAnnotation(annotation)
//        
//        if #available(iOS 16.0, *) {
//            let config = MKStandardMapConfiguration(emphasisStyle: .muted)
//            config.pointOfInterestFilter = .excludingAll
//            mapKit.preferredConfiguration = config
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation { return nil }
//        
//        let identifier = "EventMarker"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//        
//        if annotationView == nil {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//            annotationView?.markerTintColor = .systemBlue
//            annotationView?.glyphImage = UIImage(systemName: "play.fill")
//        } else {
//            annotationView?.annotation = annotation
//        }
//        
//        return annotationView
//    }
//}




//
//  DashboardVC.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//
//
//import UIKit
//import MapKit
//
//class DashboardVC: BaseViewController {
//    
//    // MARK: - Outlets
//    @IBOutlet weak var header: Header!
//    @IBOutlet weak var infoPopUpView: UIView!
//    @IBOutlet weak var infoPopupTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var mapKit: MKMapView!
//    @IBOutlet weak var missionBtnView: UIButton!
//    @IBOutlet weak var missionLabel: UILabel!
//    @IBOutlet weak var flterLabel: UILabel!
//    @IBOutlet weak var signalLabel: UILabel!
//    @IBOutlet weak var newMissionLabel: UILabel!
//    @IBOutlet weak var listOfFilterVIew: UIStackView!
//    @IBOutlet weak var missionContainer: UIStackView!
//    @IBOutlet weak var routeLabel: UILabel!
//    @IBOutlet weak var route: UIStackView!
//    @IBOutlet weak var filterMapContainer: UIStackView!
//    @IBOutlet weak var newMIssionContainer: UIStackView!
//    @IBOutlet weak var signalsConatiner: UIStackView!
//    @IBOutlet weak var plusImage: UIImageView!
//    
//    private var sheetDelegate: BottomSheetTransitionDelegate?
//    private var isFilterExpanded = false
//    private var isPopupVisible = false
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//        attachHeader(header)
//        setupInfoPopup()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        showValidationPopup()
//    }
//    
//    // MARK: - IBActions
//    @IBAction func onPressFilter(_ sender: Any) {
//        performSegue(withIdentifier: NavigationKeys.filter.rawValue, sender: self)
//    }
//    
//    @IBAction func onPressFilterMap(_ sender: Any) {
//        openFilterMap()
//    }
//    
//    @IBAction func onPressSignals(_ sender: Any) {
//        performSegue(withIdentifier: NavigationKeys.signals.rawValue, sender: self)
//    }
//    
//    override func onHeaderRightTap() {
//        toggleInfoPopup()
//    }
//}
//
//// MARK: - Info Popup
//extension DashboardVC {
//    private func setupInfoPopup() {
//        view.bringSubviewToFront(header)
//        infoPopupTopConstraint.constant = 600
//        view.layoutIfNeeded()
//    }
//
//    private func toggleInfoPopup() {
//        isPopupVisible.toggle()
//        infoPopupTopConstraint.constant = isPopupVisible ? 0 : 600
//
//        UIView.animate(
//            withDuration: 0.35,
//            delay: 0,
//            usingSpringWithDamping: 0.88,
//            initialSpringVelocity: 0.4,
//            options: [.curveEaseInOut]
//        ) {
//            self.view.layoutIfNeeded()
//        }
//    }
//}
//
//// MARK: - Setup
//extension DashboardVC {
//    
//    func setup() {
//        setupMap()
//        setupLabels()
//        prepareFilterView()
//        handleTapGestures()
//    }
//    
//    private func setupLabels() {
//        [missionLabel, flterLabel, signalLabel, newMissionLabel, routeLabel].forEach {
//            $0?.font = AppFont.get(.bold, size: 14)
//        }
//    }
//    
//    private func handleTapGestures() {
//        plusImage.isUserInteractionEnabled = true
//        plusImage.addTapGesture(target: self, action: #selector(onPlusTapped))
//    }
//    
//    @objc private func onPlusTapped() {
//        isFilterExpanded ? hideFilterView() : showFilterView()
//        isFilterExpanded.toggle()
//        rotatePlusImage(expanded: isFilterExpanded)
//    }
//    
//    private func rotatePlusImage(expanded: Bool) {
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 0.7,
//            initialSpringVelocity: 0.5,
//            options: [.curveEaseInOut]
//        ) {
//            self.plusImage.transform = expanded
//                ? CGAffineTransform(rotationAngle: .pi / 4)
//                : .identity
//        }
//    }
//    
//    func openFilterMap() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let filterMapVC = storyboard.instantiateViewController(withIdentifier: NavigationKeys.filterMap.rawValue)
//        
//        let delegate = BottomSheetTransitionDelegate(height: 320)
//        sheetDelegate = delegate
//        filterMapVC.modalPresentationStyle = .custom
//        filterMapVC.transitioningDelegate = delegate
//        present(filterMapVC, animated: true)
//    }
//}
//
//// MARK: - Filter Animation
//extension DashboardVC {
//    
//    func prepareFilterView() {
//        listOfFilterVIew.isHidden = false
//        listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
//        listOfFilterVIew.alpha = 0
//        listOfFilterVIew.arrangedSubviews.forEach {
//            $0.transform = CGAffineTransform(translationX: 200, y: 0)
//            $0.alpha = 0
//        }
//    }
//    
//    func hideFilterView() {
//        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
//            UIView.animate(
//                withDuration: 0.2,
//                delay: 0.03 * Double(index),
//                options: [.curveEaseIn]
//            ) {
//                view.transform = CGAffineTransform(translationX: 200, y: 0)
//                view.alpha = 0
//            }
//        }
//        
//        UIView.animate(
//            withDuration: 0.25,
//            delay: 0.1,
//            options: [.curveEaseIn],
//            animations: {
//                self.listOfFilterVIew.transform = CGAffineTransform(translationX: 150, y: 0)
//                self.listOfFilterVIew.alpha = 0
//            },
//            completion: { _ in
//                self.listOfFilterVIew.isHidden = true
//            }
//        )
//    }
//    
//    func showFilterView() {
//        listOfFilterVIew.isHidden = false
//        UIView.animate(
//            withDuration: 0.35,
//            delay: 0,
//            usingSpringWithDamping: 0.85,
//            initialSpringVelocity: 0.5,
//            options: [.curveEaseOut]
//        ) {
//            self.listOfFilterVIew.transform = .identity
//            self.listOfFilterVIew.alpha = 1
//        }
//        
//        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
//            UIView.animate(
//                withDuration: 0.4,
//                delay: 0.05 * Double(index),
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.5,
//                options: [.curveEaseOut]
//            ) {
//                view.transform = .identity
//                view.alpha = 1
//            }
//        }
//    }
//}
//
//// MARK: - Popup
//extension DashboardVC {
//    
//    private func showValidationPopup() {
//        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else { return }
//        
//        ForgotPasswordPopUp.show(
//            in: self.view,
//            message: "Do you want to enable biometric authentication?",
//            onConfirm: { [weak self] _ in
//                PreferenceManager.hasAskedBiometric = true
//                PreferenceManager.isBiometricEnabled = true
//            },
//            onCancel: { [weak self] in
//                PreferenceManager.hasAskedBiometric = true
//                PreferenceManager.isBiometricEnabled = false
//            }
//        )
//    }
//}
//
//// MARK: - Map
//extension DashboardVC: MKMapViewDelegate {
//    
//    private func setupMap() {
//        mapKit.delegate = self
//        mapKit.layer.cornerRadius = 12
//        mapKit.clipsToBounds = true
//        
//        let initialLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
//        let region = MKCoordinateRegion(
//            center: initialLocation,
//            latitudinalMeters: 1000,
//            longitudinalMeters: 1000
//        )
//        mapKit.setRegion(region, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = initialLocation
//        annotation.title = "10Play Event"
//        annotation.subtitle = "Join the cinematic experience"
//        mapKit.addAnnotation(annotation)
//        
//        if #available(iOS 16.0, *) {
//            let config = MKStandardMapConfiguration(emphasisStyle: .muted)
//            config.pointOfInterestFilter = .excludingAll
//            mapKit.preferredConfiguration = config
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation { return nil }
//        
//        let identifier = "EventMarker"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//        
//        if annotationView == nil {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//            annotationView?.markerTintColor = .systemBlue
//            annotationView?.glyphImage = UIImage(systemName: "play.fill")
//        } else {
//            annotationView?.annotation = annotation
//        }
//        
//        return annotationView
//    }
//}






//
//  DashboardVC.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit
import MapKit

class DashboardVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var header: Header!
    @IBOutlet weak var infoPopUpView: UIView!
    @IBOutlet weak var infoPopupTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var missionBtnView: UIButton!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var flterLabel: UILabel!
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var newMissionLabel: UILabel!
    @IBOutlet weak var listOfFilterVIew: UIStackView!
    @IBOutlet weak var missionContainer: UIStackView!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var route: UIStackView!
    @IBOutlet weak var filterMapContainer: UIStackView!
    @IBOutlet weak var newMIssionContainer: UIStackView!
    @IBOutlet weak var signalsConatiner: UIStackView!
    @IBOutlet weak var plusImage: UIImageView!
    
    private var sheetDelegate: BottomSheetTransitionDelegate?
    private var isFilterExpanded = false
    private var isPopupVisible = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        attachHeader(header)
        setupInfoPopup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showValidationPopup()
    }
    
    // MARK: - IBActions
    @IBAction func onPressFilter(_ sender: Any) {
        performSegue(withIdentifier: NavigationKeys.filter.rawValue, sender: self)
    }
    
    @IBAction func onPressFilterMap(_ sender: Any) {
        openFilterMap()
    }
    
    @IBAction func onPressSignals(_ sender: Any) {
        performSegue(withIdentifier: NavigationKeys.signals.rawValue, sender: self)
    }
    
    override func onHeaderRightTap() {
        toggleInfoPopup()
    }
}

// MARK: - Info Popup
extension DashboardVC {

    private func setupInfoPopup() {
        view.bringSubviewToFront(header)
        infoPopupTopConstraint.constant = 600
        view.layoutIfNeeded()
        setupInfoPopupContent()
    }

    private func setupInfoPopupContent() {
        infoPopUpView.backgroundColor = .white
        infoPopUpView.subviews.forEach { $0.removeFromSuperview() }

        // Timestamp label
        let timestampLabel = UILabel()
        timestampLabel.text = "Dernier message envoyé : 2026-04-10 10:24:19"
        timestampLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        timestampLabel.textColor = .darkGray
        timestampLabel.textAlignment = .center
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        infoPopUpView.addSubview(timestampLabel)

        // Top divider
        let topDivider = makeDivider()
        infoPopUpView.addSubview(topDivider)

        // Missions — replace with your real data
        let missions = [
            "LRYE (Tour 1 / Passage 0)",
            "Distribution Presse (Tour 1 / Passage 0)",
            "Essais reccursivité (Tour 1 / Passage 0)"
        ]

        var previousAnchor = topDivider.bottomAnchor

        for mission in missions {
            let label = UILabel()
            label.text = mission
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            infoPopUpView.addSubview(label)

            let divider = makeDivider()
            infoPopUpView.addSubview(divider)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: previousAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: infoPopUpView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: infoPopUpView.trailingAnchor, constant: -16),

                divider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                divider.leadingAnchor.constraint(equalTo: infoPopUpView.leadingAnchor),
                divider.trailingAnchor.constraint(equalTo: infoPopUpView.trailingAnchor),
                divider.heightAnchor.constraint(equalToConstant: 0.5)
            ])

            previousAnchor = divider.bottomAnchor
        }

        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: infoPopUpView.topAnchor, constant: 12),
            timestampLabel.leadingAnchor.constraint(equalTo: infoPopUpView.leadingAnchor, constant: 16),
            timestampLabel.trailingAnchor.constraint(equalTo: infoPopUpView.trailingAnchor, constant: -16),

            topDivider.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 12),
            topDivider.leadingAnchor.constraint(equalTo: infoPopUpView.leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: infoPopUpView.trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }

    private func toggleInfoPopup() {
        isPopupVisible.toggle()
        infoPopupTopConstraint.constant = isPopupVisible ? 0 : 600

        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.4,
            options: [.curveEaseInOut]
        ) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup
extension DashboardVC {
    
    func setup() {
        setupMap()
        setupLabels()
        prepareFilterView()
        handleTapGestures()
    }
    
    private func setupLabels() {
        [missionLabel, flterLabel, signalLabel, newMissionLabel, routeLabel].forEach {
            $0?.font = AppFont.get(.bold, size: 14)
        }
    }
    
    private func handleTapGestures() {
        plusImage.isUserInteractionEnabled = true
        plusImage.addTapGesture(target: self, action: #selector(onPlusTapped))
    }
    
    @objc private func onPlusTapped() {
        isFilterExpanded ? hideFilterView() : showFilterView()
        isFilterExpanded.toggle()
        rotatePlusImage(expanded: isFilterExpanded)
    }
    
    private func rotatePlusImage(expanded: Bool) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut]
        ) {
            self.plusImage.transform = expanded
                ? CGAffineTransform(rotationAngle: .pi / 4)
                : .identity
        }
    }
    
    func openFilterMap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterMapVC = storyboard.instantiateViewController(withIdentifier: NavigationKeys.filterMap.rawValue)
        
        let delegate = BottomSheetTransitionDelegate(height: 320)
        sheetDelegate = delegate
        filterMapVC.modalPresentationStyle = .custom
        filterMapVC.transitioningDelegate = delegate
        present(filterMapVC, animated: true)
    }
}

// MARK: - Filter Animation
extension DashboardVC {
    
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
        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.03 * Double(index),
                options: [.curveEaseIn]
            ) {
                view.transform = CGAffineTransform(translationX: 200, y: 0)
                view.alpha = 0
            }
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
            options: [.curveEaseOut]
        ) {
            self.listOfFilterVIew.transform = .identity
            self.listOfFilterVIew.alpha = 1
        }
        
        listOfFilterVIew.arrangedSubviews.enumerated().forEach { index, view in
            UIView.animate(
                withDuration: 0.4,
                delay: 0.05 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut]
            ) {
                view.transform = .identity
                view.alpha = 1
            }
        }
    }
}

// MARK: - Validation Popup
extension DashboardVC {
    
    private func showValidationPopup() {
        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else { return }
        
        ForgotPasswordPopUp.show(
            in: self.view,
            message: "Do you want to enable biometric authentication?",
            onConfirm: { [weak self] _ in
                PreferenceManager.hasAskedBiometric = true
                PreferenceManager.isBiometricEnabled = true
            },
            onCancel: { [weak self] in
                PreferenceManager.hasAskedBiometric = true
                PreferenceManager.isBiometricEnabled = false
            }
        )
    }
}

// MARK: - Map
extension DashboardVC: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "EventMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemBlue
            annotationView?.glyphImage = UIImage(systemName: "play.fill")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
