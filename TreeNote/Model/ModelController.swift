//
//  ModelController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 28.10.2020.
//

import UIKit

class ModelController {
    static var shared: ModelController = {
        let instance = ModelController();
        return instance;
    }()
    
    var rootNode:Contention!
    
    func childsForNodeId(id:String) -> [String] {
        return [];
    }
    
    public var contentionsMap: [String: Contention] = [:]
    public var childsMap: [String: [Contention]] = [:]
    public var childsTopicsMap: [String: [Contention]] = [:]
    public func nextId() -> String
    {
        var id = "\(Int.random(in: 1..<1000000))"
        
        while ModelController.shared.contentionsMap[id] != nil
        {
            id = "\(Int.random(in: 1..<1000000))"
        }
        return id
    }
    public func saveData()
    {
        var contentionsArray:[Contention] = []
        ModelController.recursiveAddToArray(self.rootNode, &contentionsArray)
        
        DataManager.saveContentions(contentionsArray)
    }
    
    static func recursiveAddToArray(_ contention:Contention,  _ array:inout [Contention])
    {
        array.append(contention)
        for childContention in contention.childs()
        {
            recursiveAddToArray(childContention, &array)
        }
    }
    
    public func loadData()
    {
        let contentions =  DataManager.loadData()
        
        for contention in contentions {
            addContentionInternal(contention)
        }
        if contentionsMap["root"] == nil
        {
            addContentionInternal(Contention("root", "root","-1"))
        }
        self.rootNode = contentionsMap["root"]
        self.rootNode.topic = true
        reloadTopicsMap()
    }
    
    private init()
    {
        
    }
    
    func reloadTopicsMap()
    {
        childsTopicsMap = [:]
        recursiveAddChildTopics(rootNode)
    }
    func recursiveAddChildTopics(_ contention: Contention)
    {
        if contention.topic
        {
            childsTopicsMap[contention.id] = []
            if let parentTopic = contention.parentTopic()
            {
                childsTopicsMap[parentTopic.id]!.append(contention)
            }
        }
        for childContention in contention.childs()
        {
            recursiveAddChildTopics(childContention)
        }
    }
    
    func addContentionInternal(_ contention:Contention)
    {
        contentionsMap[contention.id] = contention
        childsMap[contention.id] = []
        let parentExist = childsMap[contention.parentContentionId] != nil
        if parentExist && !childsMap[contention.parentContentionId]!.contains(contention)
        {
            childsMap[contention.parentContentionId]?.append(contention)
        }
    }
    
    public func addContention(_ contention:Contention)
    {
        addContentionInternal(contention)
        saveData()
    }
    
    public func removeContention(_ contention:Contention)
    {
        if let parentContention = contention.parent()
        {
            childsMap[parentContention.id] = childsMap[parentContention.id]!.filter{ $0 != contention }
            contentionsMap[contention.id] = nil
        }
        reloadTopicsMap()
        saveData()
    }
    
    public func markAsTopic(_ contention:Contention, _ topic:Bool)
    {
        contention.topic = topic
        self.reloadTopicsMap()
        saveData()
    }
    
    public func collapse(_ contention:Contention)
    {
        contention.collapce = !contention.collapce
        saveData()
    }
    
    
}

