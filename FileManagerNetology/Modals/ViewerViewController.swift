//
//  ViewerViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 29.07.23.
//

import UIKit

class ViewerViewController: UIViewController {

    var checkStatus: TypeFiles? {
        didSet {
            switch checkStatus.self {
            case .imageFile:
                print("babah!!!!")
                windowImageView.isHidden = false
                windowImageView.image = image
            case .textFile:
                print("txt")
                windowTextView.isHidden = false
                windowTextView.text = text
            case .videoFile:
                print("vid")
            default: ()
            }
        }
    }
    
    var image: UIImage?
    var text: String?
        
//MARK: ITEMs
    private let mainView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let windowImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    private let windowTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray5
        $0.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.textColor = .black
        $0.isHidden = true
        return $0
    }(UITextView())
    
    private lazy var buttonX: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .clear
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        $0.tintColor = .white
        $0.isHidden = false
        $0.addTarget(self, action: #selector(tapButtonX), for: .touchUpInside)
        return $0
    }(UIButton())
    
//MARK: INITs    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupUI()
    }
    
//MARK: METHODs
    @objc private func tapButtonX() {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        [windowImageView, windowTextView, buttonX].forEach({ mainView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            windowImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 54),
            windowImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            windowImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            windowImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            windowTextView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 54),
            windowTextView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            windowTextView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            windowTextView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            buttonX.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            buttonX.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            buttonX.heightAnchor.constraint(equalToConstant: 30),
            buttonX.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
