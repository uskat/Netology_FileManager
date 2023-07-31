//
//  UrlExt.swift
//  FileManagerNetology
//
//  Created by Diego Abramoff on 29.07.23.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
