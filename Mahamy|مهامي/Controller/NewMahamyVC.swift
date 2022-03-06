//
//  NewMahamyVC.swift
//  Mahamy|مهامي
//
//  Created by Develop on 1/14/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit

class NewMahamyVC: UIViewController {
    var editedMahamy : MahamyModel?
    var isCreation = true
    var editedIndex:Int?
    
    @IBOutlet weak var mahamyImage: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mahamyTitleTextField: UITextField!
    @IBOutlet weak var mahamyDetailsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.prefersLargeTitles = false
        
        if !isCreation {
            mainButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل مهمة"
            
        }
        if let mahamy = editedMahamy {
            mahamyTitleTextField.text = mahamy.title
            mahamyDetailsTextView.text = mahamy.details
        
        }
   
    }
    
    //MARK:- Functions  
    
    @IBAction func changeImageButtonClicked(_ sender: Any) {
          let picker = UIImagePickerController()
          picker.allowsEditing = true
          picker.delegate = self
          present(picker, animated: true, completion: nil)
      }
    
    @IBAction func addMahamyButtonClicked(_ sender: Any) {
        guard let title = mahamyTitleTextField.text, let details = mahamyDetailsTextView.text , let image = mahamyImage.image else {return}
        if isCreation {
            if title == "" || details == "" {
                
                alart(msg: "من فضلك أملأ جميع البيانات")
            }else {
                let NewMahamy = MahamyModel(title: title, image: image, details: details)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMahamyAdded"), object: nil,userInfo: ["addedMahamy":NewMahamy] )
                let alart = UIAlertController(title: "تمت الإضافة ", message: "تمت الإضافة بنجاح", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .cancel) { _ in
                    self.tabBarController?.selectedIndex = 0
                    //reset textFaild empty
                    self.setupUI()
                }
                alart.addAction(action)
                present(alart, animated: true, completion:nil)
            
            }
        }else { // else , if the view controller opened from edit not from create
            
            if title == "" || details == "" {
                
                alart(msg: "من فضلك أملأ جميع البيانات")
                
            } else {
                
                let mahamy = MahamyModel(title: title , image: image, details: details)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editedMahamyAdd"), object: nil, userInfo: ["editedMahamy":mahamy,"editedMahamyIndex":editedIndex!])
                
                let alart = UIAlertController(title: "تمت التعديل ", message: "تمت التعديل بنجاح", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                    //reset textFaild empty
                    self.setupUI()
                }
                alart.addAction(action)
                present(alart, animated: true, completion:nil)
                
            }
            
        }
        
    }
    
    func setupUI() {
        self.mahamyTitleTextField.text = ""
        self.mahamyDetailsTextView.text = ""
        self.mahamyImage.image = nil
    }
    
    func alart(msg: String) {
        let alert = UIAlertController(title: "تنبية", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "تم", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
extension NewMahamyVC :  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        mahamyImage.image = image
        
    }
}

