//
//  Contention.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 26.10.2020.
//

import UIKit

class Contention: NSObject, Codable
{
    public var text: String
    public var parentContentionId: String
    var collapce:Bool
    var topic:Bool
    var id:String
    var imageUrl:URL?
    
    public init(_ id:String, _ text:String, _ parentId:String)
    {
        self.text = text
        self.parentContentionId = parentId
        self.collapce = false
        self.topic = false
        self.id = id
//        self.color = "#FFF";
    }
    
    public func image() -> UIImage?
    {
        if let url = self.imageUrl
        {
            do
            {
                if FileManager.default.fileExists(atPath: url.path)
                {
                    let imageData = try Data(contentsOf: url)
                    return UIImage(data: imageData)
                }
            }
            catch
            {
                print("Unexpected error: \(error).")
            }
        }
        return nil
    }
    
    public func childs() -> [Contention]
    {
        return ModelController.shared.childsMap[id]!
    }
    
    func parent() -> Contention?
    {
        return ModelController.shared.contentionsMap[parentContentionId]
    }
    
    public func parentTopic() -> Contention?
    {
        var parent = self.parent()
        while parent != nil && !(parent!.topic)
        {
            parent = parent?.parent()
        }
        return parent
    }
    
    public func childTopics() -> [Contention]
    {
        return ModelController.shared.childsTopicsMap[id]!
    }
}
