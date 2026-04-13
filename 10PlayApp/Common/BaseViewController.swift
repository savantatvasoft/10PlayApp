//
//  BaseViewController.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

enum MenuAction {
    case home
    case account
    case contact
    case logout
}

class BaseViewController: UIViewController {

    let sideMenu = SliderMenu()
    var enabelBackAction:Bool = false
    
    private var loadingOverlay: LoadingOverlayView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }

    private func setupMenu() {
        sideMenu.onMenuTap = { [weak self] action in
            self?.handleMenuAction(action)
        }
    }
    
    func toggleMenu() {
        if sideMenu.superview != nil {
            sideMenu.hide()
        } else {
            sideMenu.show(in: view)
        }
    }
    
    func onHeaderRightTap() {}

    func attachHeader(_ header: Header?) {
        header?.onLeftTap = { [weak self] in
            guard let self = self else { return }
            
            if self.enabelBackAction {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.toggleMenu()
            }
        }
        
        header?.onRightTap = { [weak self] in
            self?.onHeaderRightTap()
        }
    }
    
    func toggleLoader(show: Bool, message: String? = nil, isTransparent: Bool = false) {
        if show {
            if let existing = loadingOverlay { return }
            let overlay = LoadingOverlayView(message: message, isTransparent: isTransparent)
            overlay.frame = self.view.bounds
            overlay.alpha = 0
            
            self.view.addSubview(overlay)
            self.loadingOverlay = overlay
            
            UIView.animate(withDuration: 0.3) {
                overlay.alpha = 1
            }
        } else {
            guard let overlay = loadingOverlay else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                overlay.alpha = 0
            }) { _ in
                overlay.removeFromSuperview()
                self.loadingOverlay = nil
            }
        }
    }
}

extension BaseViewController {

    func handleMenuAction(_ action: MenuAction) {
        switch action {
        case .home:
            navigateToHome()
        case .account:
            navigateToAccount()
        case .contact:
            navigateToContact()
        case .logout:
            handleLogout()
        }
    }

    func navigateToHome() {
        if self is DashboardVC { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "DashboardVCID"
        ) as! DashboardVC

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToAccount() {
        if self is ProfileVC { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AccountVC"
        ) as! ProfileVC

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToContact() {
        if self is ContactVC { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "ContactVC"
        ) as! ContactVC

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleLogout() {
        executeLogoutSequence()
    }
    
    private func executeLogoutSequence() {
        KeychainHelper.shared.delete(for: .apiKey)
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserDefaultKeys.userEmail.rawValue)
        navigateToAuthentication()
    }
    
    private func navigateToAuthentication() {
        guard let window = view.window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyboard.instantiateViewController(withIdentifier: "AuthenticationVCID")
        let nav = UINavigationController(rootViewController: authVC)
        nav.isNavigationBarHidden = true
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = nav
        }, completion: { _ in
            window.makeKeyAndVisible()
        })
    }
}
