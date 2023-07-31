//
//  FileManagerService.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import UIKit

protocol FileManagerServiceProtocol {
    func contentsOfDirectory()
    func createDirectory()
    func generateFiles()
    func addImageFile(named name: NSString)
    func createTextFile()
    func removeContent(_ file: String)
    func removeAll()
}

class FileManagerService {
    
    let manager = FileManager.default
    var files: [URL] = []
    var topValue: CGFloat = 0.9
    var bottomValue: CGFloat = 0.1
    static let shared = FileManagerService()
    private init() {}

    func contentsOfDirectory() {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            files = try manager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
        } catch let error {
            print("🚫 ContentsOfDirectory failed. Error: \(dump(error))")
        }
    }
    
    func createDirectory(withName name: String) {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            let directoryUrl = documentsUrl.appendingPathComponent(name, conformingTo: .folder)
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: false)
            contentsOfDirectory()
        } catch let error {
            print("🚫 CreateFolder failed. Error: \(dump(error))")
        }
    }
    
    func generateFiles() {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            for name in filebase {
                var data: Data?
                let myExtension = (name as NSString).pathExtension //String(Array(Set(name).subtracting(Set(name.dropLast(3)))))
                switch myExtension {
                    case "jpg":
                        let image = UIImage(named: String(name.dropLast(4)))
                        data = image?.jpegData(compressionQuality: 1.0)
                    case "txt":
                        let text = texts[name]
                        data = text?.data(using: .utf8)
                    default: ()
                }
                let filePath = documentsUrl.appending(path: name)
                manager.createFile(atPath: filePath.path(), contents: data)
            }
            contentsOfDirectory()
        } catch let error {
            print("🚫 GenerateFiles failed. Error: \(dump(error))")
        }
    }
    
    func addImageFile(named name: String, image: UIImage) {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            print("image = \(image)")
            
//            let image1 = UIImage(named: name)
            let data = image.jpegData(compressionQuality: 1.0)
            let filePath = documentsUrl.appending(path: name + ".jpg")
            manager.createFile(atPath: filePath.path(), contents: data)
            contentsOfDirectory()
        } catch let error {
            print("🚫 CreateImageFile failed. Error: \(dump(error))")
        }
    }

    func createTextFile(named name: String, withText text: String) {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            let textPath = documentsUrl.appending(path: name + ".txt")
            let textData = text.data(using: .utf8)
            manager.createFile(atPath: textPath.path(), contents: textData)
            contentsOfDirectory()
        } catch let error {
            print("🚫 CreateTextFile failed. Error: \(dump(error))")
        }
    }
    
    func removeContent(_ file: URL) {
        do {
            try manager.removeItem(atPath: file.path())
            contentsOfDirectory()
        } catch let error {
            print("🚫 removeContent failed. Error: \(dump(error))")
        }
    }
    
    func removeAll() {
        do {
            for file in files {
                try manager.removeItem(at: file)
                contentsOfDirectory()
            }
        } catch let error {
            print("🚫 RemoveAll failed. Error: \(dump(error))")
        }
    }
}
