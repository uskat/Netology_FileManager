//
//  ChangePassViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 06.08.23.
//

import UIKit

class ChangePassViewController: UIViewController {

    var credentials = Credentials(pass: "")
     
//MARK: ITEMs
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 10
        $0.axis = .vertical
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
        
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text = "Change password form"
        $0.textColor = .black
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let oldPassTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Type old password"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        $0.layer.cornerRadius = 6
        $0.textAlignment = .center
        $0.backgroundColor = .systemGray5
        return $0
    }(UITextField())
    
    private let newPassTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Type new password"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        $0.layer.cornerRadius = 6
        $0.textAlignment = .center
        $0.backgroundColor = .systemGray5
        return $0
    }(UITextField())
    
    private let repeatNewPassTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Repeat new password"
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        $0.layer.cornerRadius = 6
        $0.textAlignment = .center
        $0.backgroundColor = .systemGray5
        return $0
    }(UITextField())
    
    private let okButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("OK", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemTeal
        $0.layer.cornerRadius = 6
        $0.addTarget(nil, action: #selector(okButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Cancel", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemTeal
        $0.layer.cornerRadius = 6
        $0.addTarget(nil, action: #selector(cancelButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupUI()
    }
    
//MARK: METHODs
    @objc private func okButtonAction() {
        let (isPassCorrect, message) = getPass()

        guard isPassCorrect else {
            alert(withMessage: message)
            return
        }
        
        guard let pass = newPassTextField.text, let repeatPass = repeatNewPassTextField.text else {
            print("Unable to retrieve password's values from textFields")
            return
        }
        
        guard repeatPass == pass else {
            print("Re-entered password does not match the first value")
            alert(withMessage: "re-entered password does not match the first value")
            return
        }
        
        guard pass.count > 3 else {
            print("Password must be at least four characters long")
            alert(withMessage: "Password must be at least four characters long")
            return
        }
        
        updatePass(with: repeatPass) ? dismiss(animated: true) : alert(withMessage: "Unable to update password")
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
    
    private func getPass() -> (Bool, String)  {
        var message: String = ""
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.service,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        guard status == errSecItemNotFound || status == errSecSuccess else {
            message = "Unable to get password. Error = \(status)"
            print(message)
            return (false, message)
        }

        guard status != errSecItemNotFound else {
            message = "Password not found. Еггог = \(status)"
            print(message)
            return (false, message)
        }
        
        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            message = "Unable to retrieve password from data"
            print(message)
            return (false, message)
        }
        guard password == oldPassTextField.text ?? "" else {
            message = "Incorrect old password"
            print(message)
            return (false, message)
        }
        return (true, "")
    }
    
    private func updatePass(with pass: String) -> Bool {
        guard let passData = pass.data(using: .utf8) else {
            print("Unable to retrieve data from password")
            return false
        }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.service,
            kSecReturnData: false
        ] as [CFString : Any] as CFDictionary

        let attributeToUpdate = [
            kSecValueData: passData
        ] as [CFString : Any] as CFDictionary

        let status = SecItemUpdate(query, attributeToUpdate)

        guard status == errSecSuccess else {
            print("Unable to update password. Error = \(status)")
            return false
        }
        print("Password successfully updated.")
        return true
    }
    
    private func alert(withMessage message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {
            _ in print("alert Ok")
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }

    private func setupUI() {
        view.addSubview(stackView)
        [titleLabel, oldPassTextField, newPassTextField, repeatNewPassTextField, okButton, cancelButton].forEach({ stackView.addArrangedSubview($0) })
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}




//@objc private func resetPassButtonAction() {
//    print("resetPassButton tapped")
//    credentials = Credentials(pass: "123")
//    
//    let query = [
//        kSecClass: kSecClassGenericPassword,
//        kSecAttrService: credentials.service,
//        kSecReturnData: false
//    ] as [CFString : Any] as CFDictionary
//
//    let status = SecItemDelete(query)
//    
//    guard status == errSecItemNotFound || status == errSecSuccess else {
//        print("Unable to delete password. Error = \(status)")
//        return
//    }
//    userDefaults.set(false, forKey: isPassExist)
//    checkPassExist()
//    print("Password successfully deleted.")
//
//}
