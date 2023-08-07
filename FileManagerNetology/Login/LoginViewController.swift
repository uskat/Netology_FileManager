//
//  LoginViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 03.08.23.
//

import UIKit
import Security

class LoginViewController: UIViewController {
    
    private var isRepeat: Bool = false
    private var passToCheck: String = ""
    private var credentials = Credentials(pass: "")
    private let userDefaults = UserDefaults.standard
    
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
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
        $0.text = "Registration"
        $0.textColor = .black
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let passTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Type password"
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

//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkPassExist()
        setupUI()
    }
    
//MARK: METHODs
    @objc private func okButtonAction() {
        switch userDefaults.bool(forKey: isPassExist) {
        case true:
            print("okButton tapped (Sing In)")
            let (isPassCorrect, message) = getPass()
            if isPassCorrect {
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.sceneDelegate?.openMainViewController()
            } else {
                alert(with: message)
            }
        case false:
            print("okButton tapped (Sing Up)")
            guard let pass = passTextField.text else { return }
            
            guard pass.count > 3 else {
                alert(with: "Password must be at least four characters long")
                return
            }
            
            guard isRepeat else {
                passTextField.text = ""
                passTextField.placeholder = "Repeat password"
                okButton.setTitle("Confirm", for: .normal)
                isRepeat = true
                passToCheck = pass
                return
            }

            guard pass == passToCheck else {
                alert(with: "Re-entered password does not match the first value")
                return
            }
            
            credentials = Credentials(pass: pass)
            savePass(with: credentials)
            userDefaults.set(true, forKey: isSortAscending)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.sceneDelegate?.openMainViewController()
        }
    }
    
    private func checkPassExist() {
        switch userDefaults.bool(forKey: isPassExist) {
        case true:
            titleLabel.text = "SIGN IN:"
            passTextField.placeholder = "Type password"
        case false:
            titleLabel.text = "SIGN UP:"
            passTextField.placeholder = "Create new password"
        }
    }

    private func savePass(with credentials: Credentials) {
        guard let passData = passTextField.text?.data(using: .utf8) else {
            print("Unable to retrieve data from password")
            return
        }
        
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrService: credentials.service
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Unable to add password. Error = \(status)")
            userDefaults.set(false, forKey: isPassExist)
            return
        }
        print("New password successfully added.")
        userDefaults.set(true, forKey: isPassExist)
        checkPassExist()
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
        guard password == passTextField.text ?? "" else {
            message = "Incorrect password"
            print(message)
            return (false, message)
        }
        return (true, "")
    }
    
    private func alert(with message: String) {
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
        view.addSubview(mainView)
        mainView.addSubview(stackView)
        [titleLabel, passTextField, okButton].forEach({ stackView.addArrangedSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
}
