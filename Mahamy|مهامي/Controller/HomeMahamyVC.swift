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
        self.AllMahamyArray = MahamyStorage.getMahamy()
        
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
            MahamyStorage.CreateMahamy(mahamy: newMahamy)
        }
        
        
    }
    
    @objc func editedMahamyAdd(notification:Notification){
        
        if let editedMahamy = notification.userInfo?["editedMahamy"] as? MahamyModel{
            if let index = notification.userInfo?["editedMahamyIndex"] as? Int{
                
                AllMahamyArray[index] = editedMahamy
                tableView.reloadData()
                MahamyStorage.updateMahamy(mahamy: editedMahamy, index: index)
            }
            
        }
    }
    @objc func deletedMahamy(notification:Notification)  {
        if let index = notification.userInfo?["deletedMahamyIndex"] as? Int {
            AllMahamyArray.remove(at: index)
            tableView.reloadData()
            MahamyStorage.deleteMahamy(index: index)
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

