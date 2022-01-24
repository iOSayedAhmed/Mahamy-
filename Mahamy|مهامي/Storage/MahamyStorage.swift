//
//  MahamyStorage.swift
//  Mahamy|مهامي
//
//  Created by Develop on 1/24/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit
import CoreData
class MahamyStorage {
    
    //MARK:- CoreData CRUD Functions
    
    static func CreateMahamy(mahamy:MahamyModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let mahamyEntity = NSEntityDescription.entity(forEntityName: "Mahamy", in: managedContext) else { return}
        let mahamyObject = NSManagedObject(entity: mahamyEntity, insertInto: managedContext)
        mahamyObject.setValue(mahamy.title, forKey: "title")
        mahamyObject.setValue(mahamy.details, forKey: "details")
        if let image = mahamy.image {
            let imageData = image.jpegData(compressionQuality: 1)
            mahamyObject.setValue(imageData, forKey: "image")
        }
        
        // Now we save all data to core Data
        
        do {
            try managedContext.save()
            print("==== Success ====")
        }catch {
            print("===== Error in Saving Data to CoreData to   ==== \(error.localizedDescription)")
        }
    }
    
    
    static func getMahamy() -> [MahamyModel] {
        var Mahamy : [MahamyModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Mahamy")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for managedMahamy in result as! [NSManagedObject] {
                let title = managedMahamy.value(forKey: "title") as! String
                let details = managedMahamy.value(forKey: "details") as! String
                var image : UIImage? = nil
                if let imageData = managedMahamy.value(forKey: "image") as? Data{
                    image = UIImage(data: imageData)
                }
                let myMahamy = MahamyModel(title: title, image: image, details: details)
                
                Mahamy.append(myMahamy)
            }
        }catch {
            print("=== error in Reading Data from CoreData \(error.localizedDescription)")
        }
        return Mahamy
    }
    
    static func updateMahamy(mahamy:MahamyModel, index:Int) {
        let myMahamy: [MahamyModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Mahamy")
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(mahamy.title, forKey: "title")
            result[index].setValue(mahamy.details, forKey: "details")
            if let image = mahamy.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
            try managedContext.save()
        }catch {
            print("=== Error === \(error.localizedDescription)")
        }
        
    }
    static func deleteMahamy(index:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Mahamy")
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let mahamyIndexDelelted = result[index]
            managedContext.delete(mahamyIndexDelelted)
            
            try managedContext.save()
        }catch {
            print("=== Error === \(error.localizedDescription)")
        }
        
    }
    
    
    
}

