//
//  FileManagerViewController.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit
import PhotosUI

protocol FileManagerProtocol: AnyObject {
    func createFolder(withName: String)
    func saveNote(withFileName filename: String, text: String)
}

class FileManagerViewController: UIViewController {

    lazy var isActive: Bool = true {  ///Проверяем активен ли FileManager для обновления данных
        didSet {
            if isActive.self {
                tableView.reloadData()
            }
        }
    }
    let vc = SettingsViewController()
    let sideMenuVC = SideMenuViewController()
    let fileService = FileManagerService.shared
    weak var menuDelegate: SideMenuProtocol?
    
    enum ContextMenu: String {
        case create = "Create..."
        case addImage = "Add Image(s)"
        case delete = "Delete..."
        
        var imageName: String {
            switch self {
            case .create: return "plus.square" //"plus.square.on.square"
            case .addImage: return "photo.on.rectangle.angled"
            case .delete: return "minus.square"
            }
        }
    }
    
    enum ContextMenu2Lvl: String {
        case createFolder = "...folder"
        case createTextNote = "...text note"
        
        var imageName: String {
            switch self {
            case .createFolder: return "folder.badge.plus"
            case .createTextNote: return "text.badge.plus"
            }
        }
    }
    
//MARK: ITEMs
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .systemGray5
        $0.register(FilesTableViewCell.self, forCellReuseIdentifier: "FilesTableViewCell")
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
//MARK: INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        title = "Jimbo's File Manager"
        fileService.contentsOfDirectory()
        showBarButtons()
        setupUI()
        setContextMenu()
    }
    
//MARK: METHODs
    private func showBarButtons() {
        let leftButton = UIBarButtonItem(  ///Открытие SideMenu
            image: UIImage(systemName: "sidebar.left")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(openLeftMenuAction))
        
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func openLeftMenuAction() {
        menuDelegate?.didTapSideMenuButton()
    }
    
    func setContextMenu() {
        let actionCreateFolder = UIAction(title: ContextMenu2Lvl.createFolder.rawValue,
                                          image: UIImage(systemName: ContextMenu2Lvl.createFolder.imageName)) { action in
            print("action createFolder clicked")
            self.openTextFieldForTypeFolderName()
//            self.typeNameOfFolderAlert()
        }
        
        let actionCreateTextFile = UIAction(title: ContextMenu2Lvl.createTextNote.rawValue,
                                            image: UIImage(systemName: ContextMenu2Lvl.createTextNote.imageName)) { action in
            print("action createTextNote clicked")
            self.openTextEditor()
        }
        
        let actionCreate = UIMenu(title: ContextMenu.create.rawValue,
                                  image: UIImage(systemName: ContextMenu.create.imageName),
                                  children: [actionCreateFolder, actionCreateTextFile])
        
        let actionAddImage = UIAction(title: ContextMenu.addImage.rawValue,
                                 image: UIImage(systemName: ContextMenu.addImage.imageName)) { action in
            print("action addImage clicked")
            self.presentPicker()
        }
        
//        let actionDelete = UIAction(title: ContextMenu.delete.rawValue,
//                                  image: UIImage(systemName: ContextMenu.delete.imageName)) { action in
//            print("action delete clicked")
//            self.deleteStatus = true
//        }
        
        let contextMenu = UIMenu(title: "Context Menu", children: [actionCreate, actionAddImage])
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: nil,
                                                  image: UIImage(systemName: "line.3.horizontal")?
                                                      .withTintColor(.systemTeal, renderingMode: .alwaysOriginal),
                                                  primaryAction: nil,
                                                  menu: contextMenu)
    }
    
    private func typeNameOfFolderAlert() {
        let alertController = UIAlertController(title: "Create folder",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Type name"
        }
        
        let continueAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let textField = alertController?.textFields else { return }
            if let folderName = textField[0].text {
                self.fileService.createDirectory(withName: folderName)
            }
        }

        alertController.addAction(continueAction)
        self.present(alertController, animated: true)
    }
    
    private func checkTypeOf(content: URL) -> TypeFiles {
        if content.isDirectory {
            return .folder
        } else {
            switch content.pathExtension {
            case "jpg": return .imageFile
            case "txt": return .textFile
            case "mp4": return .videoFile
            default: return .otherFiles
            }
        }
    }
    
    private func reloadCell(row: Int, name: String, type: TypeFiles) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilesTableViewCell
        cell?.setupCellData(name: name, type: type)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FileManagerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileService.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilesTableViewCell", for: indexPath) as! FilesTableViewCell
        cell.setupCellData(name: fileService.files[indexPath.row].lastPathComponent,
                   type: checkTypeOf(content: fileService.files[indexPath.row]))
        return cell
    }
}

extension FileManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        10
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewer = ViewerViewController()
        let type = checkTypeOf(content: fileService.files[indexPath.row])
        switch type {
            case .imageFile:
                do {
                    let imageData = try Data(contentsOf: fileService.files[indexPath.row])
                    viewer.image = UIImage(data: imageData)
                } catch let error {
                    print("🚫 ReadImageFromFile failed. Error: \(dump(error))")
                }
            viewer.checkStatus = type
            present(viewer, animated: true)
            case .textFile:
                do {
                    let contents = try String(contentsOfFile: fileService.files[indexPath.row].path())
                    viewer.text = contents
                } catch let error {
                    print("🚫 ReadTextFromFile failed. Error: \(dump(error))")
                }
            viewer.checkStatus = type
            present(viewer, animated: true)
            default: ()
        }

    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let action = UIAction(title: ContextMenu.delete.rawValue,
                                  image: UIImage(systemName: ContextMenu.delete.imageName),
                                  identifier: .none) { action in
                self.fileService.removeContent(self.fileService.files[indexPath.row])
                self.tableView.reloadData()
            }
            let menu = UIMenu(options: .destructive, children: [action])
            return menu
        }
        return configuration
    }
}

//MARK: создание папки и txt-файла
extension FileManagerViewController: FileManagerProtocol {
    private func openTextFieldForTypeFolderName() {
        print("Create folder...")
        let newFolderVC = NewFolderViewController()
        fileService.topValue = 0.75
        fileService.bottomValue = 0.25
        
        newFolderVC.modalPresentationStyle = .custom
        newFolderVC.transitioningDelegate = self
        newFolderVC.delegate = self
        self.present(newFolderVC, animated: true, completion: nil)
    }
    
    func createFolder(withName name: String) {
        fileService.createDirectory(withName: name)
        fileService.contentsOfDirectory()
        tableView.reloadData()
    }
    
    private func openTextEditor() {
        print("Text editing...")
        let newTextVC = NewTextViewController()
        fileService.topValue = 0.5
        fileService.bottomValue = 0.5

        newTextVC.modalPresentationStyle = .custom
        newTextVC.transitioningDelegate = self
        newTextVC.saveDelegate = self
        self.present(newTextVC, animated: true, completion: nil)
    }
    
    func saveNote(withFileName filename: String, text: String) {
        fileService.createTextFile(named: filename, withText: text)
        fileService.contentsOfDirectory()
        tableView.reloadData()
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension FileManagerViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: imagePICKER
extension FileManagerViewController: PHPickerViewControllerDelegate  {
    private func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) {(image, error) in
                guard let fileName = item.itemProvider.suggestedName else { return }
                if let image = image as? UIImage {
                    self.fileService.addImageFile(named: fileName, image: image)
                    self.fileService.contentsOfDirectory()
                    OperationQueue.main.addOperation { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}
