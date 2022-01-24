//
//  MahamyCell.swift
//  Mahamy|مهامي
//
//  Created by Develop on 1/14/22.
//  Copyright © 2022 Develop. All rights reserved.
//

import UIKit

class MahamyCell: UITableViewCell {

    @IBOutlet weak var mahamyImage: UIImageView!
    @IBOutlet weak var mahamyTitleLabel: UILabel!
    @IBOutlet weak var mahamyDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
