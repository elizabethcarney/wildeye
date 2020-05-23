//
//  ToFindItem.swift
//  wildeye
//
//  Created by Elizabeth Carney on 5/23/20.
//  Copyright © 2020 Elizabeth Carney. All rights reserved.
//

import Foundation

class ToFindItem: NSObject, NSCoding {
   
    var title: String
    var found: Bool
    
    public init(title: String) {
        self.title = title
        self.found = false
    }
    
    // unserialize (decode) data from last app session
    required init?(coder aDecoder: NSCoder) {
        // try to decode item's title
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else { // error if no title, this item will not show up
            return nil
        }
        // check if "found" key exists
        if aDecoder.containsValue(forKey: "found") {
            self.found = aDecoder.decodeBool(forKey: "found")
        } else { // error if no "done" attribute, this item will not show up
            return nil
        }
    }
    
    // serialize (encode) data from this session
    func encode(with aCoder: NSCoder) {
        // store items in coder object
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.found, forKey: "found")
    }

}

// get mock data
extension ToFindItem {
    public class func getMockData() -> [ToFindItem] {
        return [
            ToFindItem(title: "Pinecone"),
            ToFindItem(title: "Robin"),
            ToFindItem(title: "Rabbit"),
            ToFindItem(title: "Birch Tree"),
            ToFindItem(title: "Deer"),
            ToFindItem(title: "Magnolia Leaf"),
        ]
    }
}

// invoke serialization for local persistence
extension Collection where Iterator.Element == ToFindItem {
    
    // build URL for persistence (location in Application Support)
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return url?.appendingPathComponent("itemstofind.bin")
    }
    
    // write array
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        } else {
            throw NSError(domain: "com.elizabethcarney.wildeye", code: 10, userInfo: nil)
        }
    }
    
    // read array
    func readFromPersistence() throws -> [ToFindItem] {
        if let url = Self.persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToFindItem] {
                return array
            } else {
                throw NSError(domain: "com.elizabethcarney.wildeye", code: 11, userInfo: nil)
            }
        } else {
            throw NSError(domain: "com.elizabethcarney.wildeye", code: 12, userInfo: nil)
        }
    }
    
}
