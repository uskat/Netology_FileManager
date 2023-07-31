//
//  ModalViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 29.07.23.
//

import UIKit

class PresentationController: UIPresentationController {

    let fileService = FileManagerService.shared
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
//    var topValue: CGFloat = 0.55
//    var bottomValue: CGFloat = 0.45
  
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * fileService.topValue),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * fileService.bottomValue))
    }

    override func presentationTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {  (UIViewControllerTransitionCoordinatorContext) in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 16)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

//+ extension UIView
