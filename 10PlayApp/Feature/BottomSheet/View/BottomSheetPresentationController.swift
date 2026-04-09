//
//  BottomSheetPresentationController.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//

import UIKit

class BottomSheetPresentationController: UIPresentationController {

    private let height: CGFloat
    private let dimmingView = UIView()

    init(presentedVC: UIViewController, presenting: UIViewController?, height: CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedVC, presenting: presenting)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }

    @objc private func dismiss() {
        presentedViewController.dismiss(animated: true)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        return CGRect(x: 0,
                      y: container.bounds.height - height,
                      width: container.bounds.width,  // ← true full width
                      height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        dimmingView.frame = container.bounds
        container.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

