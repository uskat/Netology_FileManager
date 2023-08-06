//
//  MainViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 28.07.23.
//

import UIKit

protocol SideMenuProtocol: AnyObject {
    func didTapSideMenuButton()
    func didTap(menuItem: SideMenuViewController.SideMenu)
    func returnToFileManager()
}

class MainViewController: UIViewController {

    var isSideMenuOpen = false
    var nvc: UINavigationController?
    let sideMenuVC = SideMenuViewController()
    let fileManagerVC = FileManagerViewController()
    lazy var fileService = FileManagerService.shared
    lazy var settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChildVC()
    }
    
    private func addChildVC() {
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: self)
        fileManagerVC.menuDelegate = self
        sideMenuVC.menuDelegate = self
        
        let nvc = UINavigationController(rootViewController: fileManagerVC)
        addChild(nvc)
        view.addSubview(nvc.view)
        nvc.didMove(toParent: self)
        self.nvc = nvc
    }
}

extension MainViewController: SideMenuProtocol {
    func didTapSideMenuButton() {
//        print("TAP")
        vcSwitcher(completion: nil)
    }
    
    func vcSwitcher(completion: (() -> Void)?) {
//        print("switch ")
        if !isSideMenuOpen {
            UIView.animate(withDuration: 0.5,  ///анимация открытия SideMenu
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut) {
                self.nvc?.view.frame.origin.x = self.fileManagerVC.view.frame.size.width - 100
            } completion: { finished in
                self.fileManagerVC.isActive = false
                self.isSideMenuOpen.toggle()
            }
        } else {
            UIView.animate(withDuration: 0.5,   ///анимация закрытия SideMenu
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut) {
                self.nvc?.view.frame.origin.x = 0
            } completion: { finished in
                self.isSideMenuOpen.toggle()
            }
        }
    }
    
    func didTap(menuItem: SideMenuViewController.SideMenu) {
        vcSwitcher(completion: nil) ///запускаем анимацию Side Menu после выбора пункта меню
        
        switch menuItem {
        case .createContentInFolder: ()
            fileService.generateFiles()
            fileManagerVC.isActive = true
            
        case .removeContentInFolder: ()
            fileService.removeAll()
            fileManagerVC.isActive = true

        case .settings:             ///
//            let vc = SettingsViewController()
            fileManagerVC.addChild(settingsVC)
            fileManagerVC.view.addSubview(settingsVC.view)
            settingsVC.view.frame = view.frame
            settingsVC.didMove(toParent: fileManagerVC)
            settingsVC.returnDelegate = self
            fileManagerVC.title = settingsVC.title
            fileManagerVC.navigationItem.rightBarButtonItem?.isHidden = true  ///Прячем контекстное меню в Settings
            fileManagerVC.navigationItem.leftBarButtonItem?.isHidden = true  ///Прячем SideMenu в Settings
        }
    }
    
    func returnToFileManager() { ///Возврат из другого дочернего vc в File Manager (в проекте: из SettingsVC в FileManagerVC)
        settingsVC.view.removeFromSuperview()
        settingsVC.didMove(toParent: nil)
        fileManagerVC.navigationItem.rightBarButtonItem?.isHidden = false ///возвращаем rightBarButton (нужен только в File Manager)
        fileManagerVC.navigationItem.leftBarButtonItem?.isHidden = false ///возвращаем leftBarButton (нужен только в File Manager)
        fileManagerVC.title = "Jimbo's File Manager"
        fileManagerVC
    }
}
