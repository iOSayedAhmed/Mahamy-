//
//  AnimationViewController.swift
//  demo
//
//  Created by Develop on 3/6/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    private let imageView : UIImageView = {
       let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        image.image = UIImage(named: "logo")
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(imageView)
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }

    func animate() {
        UIView.animate(withDuration: 0.5) {
            let size = self.view.frame.width * 2
            let diffX = size - self.view.frame.width
            let diffY = self.view.frame.height - size
            print(size, diffX,diffY)
            self.imageView.frame = CGRect(x: -(diffX/2),
                                          y: (diffY/2),
                                          width: size,
                                          height: size)
        }
        UIView.animate(withDuration: 1.3, animations: {
            self.imageView.alpha = 0
        }) { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let vc = self.storyboard?.instantiateViewController(identifier: "TabBarVC")
                    as! UITabBarController
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
}
