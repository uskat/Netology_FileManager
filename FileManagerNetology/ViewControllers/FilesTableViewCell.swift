//
//  FilesTableViewCell.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit

class FilesTableViewCell: UITableViewCell {

    private let cellView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray5
        return $0
    }(UIView())
    
    private let nameFileLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "(...)"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.backgroundColor = .clear
        return $0
    }(UILabel())
    
    private let fileImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "file")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        return $0
    }(UIImageView())
    
    let deleteStatusImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "trash.square")
        $0.tintColor = .systemTeal
        $0.isHidden = true
        return $0
    }(UIImageView())
    
//MARK: INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: METHODs
    private func setupUI() {
        [cellView, fileImageView, nameFileLabel, deleteStatusImageView].forEach({ contentView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            fileImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            fileImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            fileImageView.heightAnchor.constraint(equalToConstant: 30),
            fileImageView.widthAnchor.constraint(equalToConstant: 30),
            
            nameFileLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            nameFileLabel.leadingAnchor.constraint(equalTo: fileImageView.trailingAnchor, constant: 6),
            nameFileLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            nameFileLabel.heightAnchor.constraint(equalToConstant: 30),
            
            deleteStatusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteStatusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            deleteStatusImageView.heightAnchor.constraint(equalToConstant: 30),
            deleteStatusImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupCellData(name: String, type: TypeFiles) {
        nameFileLabel.text = name
        fileImageView.image = UIImage(systemName: type.imageName)
    }
}
