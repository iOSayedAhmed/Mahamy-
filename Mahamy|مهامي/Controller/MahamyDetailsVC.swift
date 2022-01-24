//
//  MahamyDetailsVC.swift
//  Mahamy|مهامي
//
//  Created by Develop on 1/14/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit

class MahamyDetailsVC: UIViewController {
    
    var mahamy:MahamyModel!
    var index:Int!
    @IBOutlet weak var mahamyImage: UIImageView!
    
    @IBOutlet weak var mahamyDetailsLabel: UILabel!
    @IBOutlet weak var mahamyTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(editedMahamyAdd), name: NSNotification.Name("editedMahamyAdd"), object: nil)
        
    }
    
    
    //MARK:- Functions
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "NewMahamyVC") as? NewMahamyVC {
            vc.isCreation = false
            vc.editedMahamy = mahamy
            vc.editedIndex = index
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "تنبية", message: "هل أنت متأكد من حذف هذة المهمة؟", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "تأكيد الحذف", style:.destructive) { _ in
            
            NotificationCenter.default.post(name: NSNotification.Name("deletedMahamy"), object: nil, userInfo: ["deletedMahamyIndex":self.index])
            let alert = UIAlertController(title: "تنبية", message: "تم الحذف بنجاح", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        confirmAlert.addAction(confirmAction)
        let closeAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
        confirmAlert.addAction(closeAction)
        present(confirmAlert, animated: true, completion: nil)
    }
    
    
    func setupUI() {
        mahamyTitleLabel.text = mahamy.title
        if mahamy.image != nil {
            mahamyImage.image = mahamy.image
        }else {
            mahamyImage.image = UIImage(named: "picture")
        }
        mahamyDetailsLabel.text = mahamy.details
        
    }
    
    @objc func editedMahamyAdd(notification:Notification){
        if let editedMahamy = notification.userInfo?["editedMahamy"] as? MahamyModel
        {
            
            mahamy = editedMahamy
            setupUI()
            
        }
        
        print("edited")
    }
    
    
}
