//
//  SwiftVisualizer.swift
//  SwiftVisualizerFramework
//
//  Created by Søren Mortensen on 02/03/2017.
//
//

import Foundation
import SourceKittenFramework

public class SwiftVisualizer {

    private let fileManager = FileManager()

    public init?(directory path: String) {

    }

    public init?(file path: String) {
        guard let file = File(path: path) else {
            return nil
        }

        guard let docs = SwiftDocs(file: file, arguments: []) else {
            return nil
        }

        for (key, value) in docs.docsDictionary {
            print("\(key): \(value)")
        }
    }

}
