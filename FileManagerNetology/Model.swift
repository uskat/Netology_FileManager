//
//  Model.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 26.07.23.
//

import Foundation

struct Credentials {
    var pass: String
    var service = "user credentials"
}

enum TypeFiles: String {   ///Изменить на Dictionary??
    case imageFile = "jpg"
    case textFile = "txt"
    case videoFile = "mp4"
    case otherFiles
    case folder

    var imageName: String {
        switch self {
        case .imageFile: return "photo"
        case .textFile: return "doc.text"
        case .videoFile: return "video"
        case .otherFiles: return "doc"
        case .folder: return "folder"
        }
    }
}
