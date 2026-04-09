//
//  BottomSheetTransitionDelegate.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//

import UIKit

class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private let height: CGFloat
    init(height: CGFloat) { self.height = height }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        BottomSheetPresentationController(presentedVC: presented, presenting: presenting, height: height)
    }
}
