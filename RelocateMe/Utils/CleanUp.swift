//
//  CleanUp.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/20/22.
//

import Foundation

func cleanup() {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
        for fileURL in fileURLs where fileURL.pathExtension == "plist" {
            try FileManager.default.removeItem(at: fileURL)
        }
    } catch { print(error) }
}
