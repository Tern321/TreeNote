//
//  SynchronizedObject.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 19.11.2020.
//

import UIKit

class SynchronizedObject<T>
{
    let lock = NSLock() // do we realy need this?
    
    var _Value : T?
    public var value : T? {

        set(newValue)
        {
            DispatchQueueManager.globalBackgroundSyncronizeDataQueue.sync()
            {
                lock.lock()
                self._Value = newValue
                lock.unlock()
            }
        }
        get{
            return DispatchQueueManager.globalBackgroundSyncronizeDataQueue.sync
            {
                return _Value
            }
        }
    }
    
    func getAndSetNil() ->T?
    {
        return DispatchQueueManager.globalBackgroundSyncronizeDataQueue.sync
        {
            lock.lock()
            let temp = _Value
            self._Value = nil
            lock.unlock()
            return temp
        }
    }
}
