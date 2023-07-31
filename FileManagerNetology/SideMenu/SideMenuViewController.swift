//
//  SideMenuViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 28.07.23.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var fileService = FileManagerService.shared
    weak var menuDelegate: SideMenuProtocol?
    
    enum SideMenu: String, CaseIterable {  ///Конфигурируем меню SideMenu
        case createContentInFolder = "Generate some content"
        case removeContentInFolder = "Remove all content"
        case settings = "Settings"
        
        var imageMenu: String {
            switch self {
            case .createContentInFolder: return "rectangle.stack.badge.plus" //"square.grid.3x1.folder.badge.plus"
            case .removeContentInFolder: return "rectangle.stack.badge.minus"//"trash.square"
            case .settings: return "gearshape" //"folder.badge.gearshape"
            }
        }
    }
    
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.backgroundColor = UIColor.systemTeal.cgColor
//        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//        $0.backgroundColor = .systemTeal
        return $0
    }(UIView())
    
    private let titleSideMenu: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text =
        """
        Jimbo's File Manager
        [study project]
        """
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView())
    
//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        setupUI()
    }
    
//MARK: METHODs
    private func setupUI() {
        view.addSubview(mainView)
        [titleSideMenu, tableView].forEach({ mainView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleSideMenu.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleSideMenu.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleSideMenu.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
}
    
extension SideMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        content.textProperties.color = .white
        content.text = SideMenu.allCases[indexPath.row].rawValue
        content.image = UIImage(systemName: SideMenu.allCases[indexPath.row].imageMenu)
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.tintColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        self.menuDelegate?.didTap(menuItem: SideMenu.allCases[indexPath.row])
    }
}
