//
//  SettingsViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var returnDelegate: SideMenuProtocol?
    
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let colorTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text = "Choose color set:"
        $0.textColor = .black
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
//        $0.delegate = self
//        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        return $0
    }(UITableView())
    
    private let returnButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("OK", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemTeal
        $0.addTarget(nil, action: #selector(returnButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())

//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        title = "Settings"
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

//MARK: METHODs
    @objc private func returnButtonAction() {
        self.returnDelegate?.returnToFileManager()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        [colorTitleLabel, tableView, returnButton].forEach({ mainView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            colorTitleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            colorTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            colorTitleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            returnButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        content.textProperties.color = .black
        content.text = "Color Set"
        content.textProperties.numberOfLines = 3
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.tintColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
