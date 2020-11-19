//
//  DispatchQueueManager.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 19.11.2020.
//

import UIKit

class DispatchQueueManager
{
    static public let globalBackgroundSyncronizeDataQueue = DispatchQueue( label: "globalBackgroundSyncronizeSharedData")
    
//    static var shared: DispatchQueueManager = {
//        let instance = DispatchQueueManager();
//        return instance;
//    }()
}
