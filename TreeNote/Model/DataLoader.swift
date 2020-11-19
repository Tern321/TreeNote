//
//  DataLoader.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 01.11.2020.
//

import UIKit

class DataLoader {
    
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
    
    static let dataFileUrl = getDocumentsDirectory().appendingPathComponent("data.json")
    public static func loadData() -> [Contention]
    {
        do{
            let jsonData = try Data(contentsOf: dataFileUrl)
            let decoder = JSONDecoder()
            let contentionsList:[Contention] = try decoder.decode([Contention].self, from: jsonData)
            
            return contentionsList
        } catch
        {
            print("Unexpected error: \(error).")
        }
        return []
    }
    static let dataSaveLock = NSLock()
    
    // this error should be fixed in next xcode
    static var dataToSaveObject:SynchronizedObject<Data> = SynchronizedObject()
    
    public static func saveData(_ data:Data)
    {
        dataToSaveObject.value = data
        DispatchQueue.global(qos: .background).async
        {
            dataSaveLock.lock()
            if let data = dataToSaveObject.getAndSetNil()
            {
                do{
                    try data.write(to: dataFileUrl)
                } catch
                {
                    print("Unexpected error: \(error).")
                }
            }
            dataSaveLock.unlock()
        }
    }
    
    public static func saveContentions(_ contentions:[Contention])
    {
        do{
            let encoder = JSONEncoder()
            let jsonString = try encoder.encode(contentions)
            DataLoader.saveData(jsonString)
        } catch
        {
            print("Unexpected error: \(error).")
        }
        
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public static func onStart()
    {
        //        var currentVersion = 10
        //        var serverVersion = 11
        //        var serverAvailible = false
        //        var dataString = "";
        //        if serverAvailible
        //        {
        //            if currentVersion < serverVersion
        //            {
        //                dataString = server.loadCurrentVersion()
        //            }
        //            else
        //            {
        //                dataString = loadCachedVersion()
        //            }
        //        }
        //        else
        //        {
        //            dataString = loadCachedVersion()
        //        }
        //        var changes:[String] = loadLocalChanges()
        //        var data = Data.parse(dataString)
        //        data.applyChanges(changes)
        
        //        соответственно запуск -
        //            проверяем изменилась ли сохраненная версия на сервере, скачиваем если изменилась или если не можем берем локальный кеш, применяем к нему изменения и используем
        //        обновляем главный файл когда вектор изменений становится больше чем?
    }
    public static func onDataChange(_ change:String)
    {
        //        var data = onStart()
        //        var serverAvailible = false
        //
        //        changes.append(change)
        //        if serverAvailible
        //        {
        //            var data = onStart()
        //            server.upliad(data)
        //        }
        
    }
}
