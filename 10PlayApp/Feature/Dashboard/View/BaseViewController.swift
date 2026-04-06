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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }

    private func setupMenu() {
        sideMenu.onMenuTap = { [weak self] action in
            self?.handleMenuAction(action)
        }
    }

    // MARK: - Menu Control

    func toggleMenu() {
        if sideMenu.superview != nil {
            sideMenu.hide()
        } else {
            sideMenu.show(in: view)
        }
    }

    func attachHeader(_ header: Header?) {
        header?.onLeftTap = { [weak self] in
            self?.toggleMenu()
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
        // Prevent duplicate navigation
        if self is DashboardVC { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "DashboardVCID"
        ) as! DashboardVC

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToAccount() {
        if self is AccountVC { return }

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AccountVC"
        ) as! AccountVC

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToContact() {
        print("Navigate to Contact")
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
