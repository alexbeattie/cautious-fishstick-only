//
//  BundleTest.swift
//  NewAPI
//
//  Created by Alex Beattie on 9/29/23.
//

import Foundation

//extension Bundle {
//    func decode<T: Codable>(_ file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to location \(file) in Bundle")
//        }
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle")
//        }
//        let decoder = JSONDecoder()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "y-MM-dd"
//        decoder.dateDecodingStrategy = .formatted(formatter)
//
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle")
//        }
//        return loaded
//    }
//
//}
