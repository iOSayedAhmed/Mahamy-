//
//  ViewController.swift
//  Mahamy|مهامي
//
//  Created by Develop on 1/14/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit
import CoreData

class HomeMahamyVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var AllMahamyArray : [MahamyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AllMahamyArray = getMahamy()
        
        tableView.register(UINib(nibName: "MahamyCell", bundle: nil), forCellReuseIdentifier: "MahamyCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add New Mahamy Notification to AllMahamyArray
        NotificationCenter.default.addObserver(self, selector: #selector(newMahamyAdded), name: NSNotification.Name("newMahamyAdded"), object: nil)
        // Add edited Mahamy Notification to AllMahamyArray
        NotificationCenter.default.addObserver(self, selector: #selector(editedMahamyAdd), name: NSNotification.Name("editedMahamyAdd"), object: nil)
        // Deleted Mahamy Index Notification
        NotificationCenter.default.addObserver(self, selector: #selector(deletedMahamy), name: NSNotification.Name("deletedMahamy"), object:nil)
 
    }
    
    @objc func newMahamyAdded(notification:Notification){
        //print(notification.userInfo?["addedMahamy"])
        
        if let newMahamy = notification.userInfo?["addedMahamy"] as? MahamyModel{
            AllMahamyArray.append(newMahamy)
            tableView.reloadData()
            //save to CoreDate
            CreateMahamy(mahamy: newMahamy)
        }
        
        
    }
    
    @objc func editedMahamyAdd(notification:Notification){
        
        if let editedMahamy = notification.userInfo?["editedMahamy"] as? MahamyModel{
            if let index = notification.userInfo?["editedMahamyIndex"] as? Int{
                
                AllMahamyArray[index] = editedMahamy
                tableView.reloadData()
                updateMahamy(mahamy: editedMahamy, index: index)
            }
            
        }
    }
    @objc func deletedMahamy(notification:Notification)  {
        if let index = notification.userInfo?["deletedMahamyIndex"] as? Int {
            AllMahamyArray.remove(at: index)
            tableView.reloadData()
            deleteMahamy(index: index)
        }
        
    }
    
    //MARK:- CoreData CRUD Functions
    
    func CreateMahamy(mahamy:MahamyModel) {
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
    
    func getMahamy() -> [MahamyModel] {
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
    
    func updateMahamy(mahamy:MahamyModel, index:Int) {
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
    func deleteMahamy(index:Int) {
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
extension HomeMahamyVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AllMahamyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MahamyCell", for: indexPath) as! MahamyCell
        
        cell.mahamyTitleLabel.text = AllMahamyArray[indexPath.row].title
        if AllMahamyArray[indexPath.row].image != nil {
            cell.mahamyImage.image = AllMahamyArray[indexPath.row].image
        }else {
            cell.mahamyImage.image = UIImage(named:"picture" )
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMahamy = AllMahamyArray[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(identifier: "MahamyDetailsVC") as? MahamyDetailsVC
        
        if let viewController = vc {
            viewController.mahamy = currentMahamy
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

