//
//  UIViewExt.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit

extension UIView {
    //used in ModalVC
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }
    
    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

//extension UIView {
//    func edgeTo(_ view: UIView) {
//        view.addSubview(self)
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
//        view.addSubview(self)
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
//            trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
