//
//  TriangleView.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import UIKit

class TriangleView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        
        UIColor.white.setFill()
        path.fill()
    }
}
