//
//  DetailListTableViewCell.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {
    @IBOutlet weak var bookCoverImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
