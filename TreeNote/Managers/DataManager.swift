//
//  DataLoader.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 01.11.2020.
//

import UIKit

class DataManager
{
    static let dataFileName = "data.json"
    static let dataFileUrl = getDocumentsDirectory().appendingPathComponent(dataFileName)
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public static func loadData() -> [Contention]
    {
        do{
            let jsonData = try Data(contentsOf: dataFileUrl)
            let decoder = JSONDecoder()
            let contentionsList:[Contention] = try decoder.decode([Contention].self, from: jsonData)
            cleanGarbageImages(contentionsList)
            return contentionsList
        } catch
        {
            print("Unexpected error: \(error).")
        }
        return []
    }
    
    public static func cleanGarbageImages(_ contentions:[Contention])
    {
        DispatchQueue.global(qos: .background).async
        {
            let urls = FileManager.default.urls(for: .documentDirectory)
            
            var contentionIdDictionary:[String:String] = [:]
            contentionIdDictionary[dataFileName] = ""
            
            for contention in contentions
            {
                contentionIdDictionary["\(contention.id).jpeg"] = ""
            }
            for url in urls
            {
                if !contentionIdDictionary.containsKey(url.lastPathComponent)
                {
                    do {
//                        print("delete file \(url)")
                        try FileManager.default.removeItem(at: url)
                    } catch {
                        print("Could not delete file: \(error)")
                    }
                }
            }
        }
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
            DataManager.saveData(jsonString)
        } catch
        {
            print("Unexpected error: \(error).")
        }
        
    }
    
    public static func saveImageToFile(_ image:UIImage, forContention contention:Contention) -> URL
    {
        let fileUrl = getDocumentsDirectory().appendingPathComponent("\(contention.id).jpeg")
        DispatchQueue.global(qos: .background).async
        {
            if let data = image.jpegData(compressionQuality: 0.8)
            {
                try? data.write(to: fileUrl)
            }
        }
        return fileUrl
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
