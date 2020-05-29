//
//  FileHelper.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

class FileHelper {
    
    static let shared = FileHelper()
    
    func getMediaFileURL(name: String, ext: String, needRemove: Bool = true, needCreate: Bool = false) -> URL? {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirURL = URL(fileURLWithPath: documentsFolder).appendingPathComponent("DTLivingMedias", isDirectory: true)
        let fileURL = dirURL.appendingPathComponent(name).appendingPathExtension(ext)
        
        do {
            if !FileManager.default.fileExists(atPath: dirURL.path) {
                try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            }
            if needRemove, FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
            if needCreate, !FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) {
                return nil
            }
        } catch {
            return nil
        }
        
        return fileURL
    }
    
}
