//
//  NewFolderViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 29.07.23.
//

import UIKit

class NewFolderViewController: UIViewController {

    weak var delegate: FileManagerProtocol?
    
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Create folder"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let folderName: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Type folder name..."
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        $0.backgroundColor = .systemGray5
        return $0
    }(UITextField())

    private let saveButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Save", for: .normal)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(nil, action: #selector(saveAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Cancel", for: .normal)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(nil, action: #selector(cancelAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupUI()
    }
    
    @objc private func saveAction() {
        if let folderName = folderName.text {
            delegate?.createFolder(withName: folderName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK: METHODs
    private func setupUI() {
        view.addSubview(mainView)
        [titleLabel, folderName, saveButton, cancelButton].forEach({ mainView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            saveButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -6),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 6),
            cancelButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            folderName.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),
            folderName.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            folderName.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            folderName.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.bottomAnchor.constraint(equalTo: folderName.topAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
        ])
    }
}
