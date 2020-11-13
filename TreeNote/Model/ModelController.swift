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
    
    var rootNode:Contention!;
    // init from json
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
    public func loadData()
    {
        let mainUrl = Bundle.main.url(forResource: "DataExample", withExtension: "json")!
        let contentions =  DataLoader.decodeData(pathName: mainUrl)
        
        for contention in contentions {
            addContention(contention)
        }
        self.rootNode = contentionsMap["root"]
        reloadTopicsMap()
    }
    private init()
    {
    }
    func reloadTopicsMap()
    {
        childsTopicsMap = [:]
        recursiveAddChildTopics(rootNode)
//        for( _, contention) in contentionsMap
//        {
//            if contention.topic
//            {
//                childsTopicsMap[contention.id] = []
//            }
//        }
//
//        for( id, _) in childsTopicsMap
//        {
//            let contention = contentionsMap[id]!
//            if let parentTopic = contention.parentTopic()
//            {
//                childsTopicsMap[parentTopic.id]!.append(contention)
//            }
//        }
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
    public func addContention(_ contention:Contention)
    {
        contentionsMap[contention.id] = contention
        childsMap[contention.id] = []
        let parentExist = childsMap[contention.parentContentionId] != nil
        if parentExist && !childsMap[contention.parentContentionId]!.contains(contention)
        {
            childsMap[contention.parentContentionId]?.append(contention)
        }
    }
    public func removeContention(_ contention:Contention)
    {
        if let parentContention = contention.parent()
        {
            childsMap[parentContention.id] = childsMap[parentContention.id]!.filter{ $0 != contention }
            contentionsMap[contention.id] = nil
        }
        reloadTopicsMap()
    }
    
}

