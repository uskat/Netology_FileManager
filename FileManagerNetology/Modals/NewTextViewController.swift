//
//  NewTextViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 29.07.23.
//

import UIKit

class NewTextViewController: UIViewController, UITextViewDelegate {

    weak var saveDelegate: FileManagerProtocol?
    
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "New text note"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let filename: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Type filename..."
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        $0.backgroundColor = .systemGray5
        return $0
    }(UITextField())
    
    private let textView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray5
        $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
        $0.text = "Type text note..."
        $0.textColor = UIColor.lightGray
        return $0
    }(UITextView())

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
        textView.delegate = self
    }
    
//MARK: METHODs
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type text note......"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc private func saveAction() {
        if let filename = filename.text {
            saveDelegate?.saveNote(withFileName: filename, text: textView.text)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        [titleLabel, filename, textView, saveButton, cancelButton].forEach({ mainView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),

            filename.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            filename.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            filename.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            filename.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            saveButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -6),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 6),
            cancelButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            textView.topAnchor.constraint(equalTo: filename.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            textView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),
        ])
    }
}
