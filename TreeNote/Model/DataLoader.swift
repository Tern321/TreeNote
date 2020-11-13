//
//  DataLoader.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 01.11.2020.
//

import UIKit

class DataLoader: NSObject {

    static var fm = FileManager.default
    
    public static func decodeData(pathName: URL) -> [Contention]
    {
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            let contentionsList:[Contention] = try decoder.decode([Contention].self, from: jsonData)
            
            return contentionsList
        } catch
        {
            print("Unexpected error: \(error).")
        }
        return []
    }
}
