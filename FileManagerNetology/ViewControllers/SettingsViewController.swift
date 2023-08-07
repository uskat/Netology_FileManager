//
//  SettingsViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let userDefaults = UserDefaults.standard
    private var isAscending: Bool = true {
        didSet {
            switch isAscending.self {
            case true:
                sortAscendingButton.isUserInteractionEnabled = false
                sortAscendingButton.backgroundColor = .lightGray
                sortDescendingButton.isUserInteractionEnabled = true
                sortDescendingButton.backgroundColor = .black
                sortingCurrentSettingsLabel.text = " Ascending Sort"
                return
            case false:
                sortAscendingButton.isUserInteractionEnabled = true
                sortAscendingButton.backgroundColor = .black
                sortDescendingButton.isUserInteractionEnabled = false
                sortDescendingButton.backgroundColor = .lightGray
                sortingCurrentSettingsLabel.text = " Descending sort"
                return
            }
        }
    }
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
    
    private let sortTitlesStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let sortingTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text = "Files sorted: "
        $0.textColor = .black
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private let sortingCurrentSettingsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let sortStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        return $0
    }(UIStackView())
    
    private let sortAscendingButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Ascending sort", for: .normal)
        $0.setTitleColor(.systemGray5, for: .normal)
        $0.backgroundColor = .black
        $0.addTarget(nil, action: #selector(sortAscendingButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let sortDescendingButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Descending sort", for: .normal)
        $0.setTitleColor(.systemGray5, for: .normal)
        $0.backgroundColor = .black
        $0.addTarget(nil, action: #selector(sortDescendingButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 10
        $0.axis = .vertical
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let changePassButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Change or Reset Password", for: .normal)
        $0.setTitleColor(.systemTeal, for: .normal)
        $0.backgroundColor = .systemGray5
        $0.layer.borderColor = UIColor.systemTeal.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 6
        $0.addTarget(nil, action: #selector(changePassButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
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
        isAscending = userDefaults.bool(forKey: isSortAscending) ? true : false
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

//MARK: METHODs
    @objc private func sortAscendingButtonAction() {
        isAscending = true
        userDefaults.set(true, forKey: isSortAscending)
    }
    
    @objc private func sortDescendingButtonAction() {
        isAscending = false
        userDefaults.set(false, forKey: isSortAscending)
    }
    
    @objc private func changePassButtonAction() {
        let vc = ChangePassViewController()
        present(vc, animated: true)
    }
    
    @objc private func returnButtonAction() {
        self.returnDelegate?.returnToFileManager()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        [colorTitleLabel, tableView, sortTitlesStackView, sortStackView, stackView].forEach({ mainView.addSubview($0) })
        [sortingTitleLabel, sortingCurrentSettingsLabel].forEach({ sortTitlesStackView.addArrangedSubview($0) })
        [sortAscendingButton, sortDescendingButton].forEach({ sortStackView.addArrangedSubview($0) })
        [changePassButton, returnButton].forEach({ stackView.addArrangedSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            colorTitleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            colorTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            colorTitleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: colorTitleLabel.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            sortTitlesStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            sortTitlesStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            sortTitlesStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            sortTitlesStackView.heightAnchor.constraint(equalToConstant: 30),
            
            sortStackView.topAnchor.constraint(equalTo: sortTitlesStackView.bottomAnchor, constant: 12),
            sortStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            sortStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            sortStackView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: 110)
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
        50
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
