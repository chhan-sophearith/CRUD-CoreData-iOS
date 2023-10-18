//
//  TableViewCell.swift
//  CoreDataDemo-iOS
//
//  Created by Chhan Sophearith on 18/10/23.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var createAtLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    func setupValue(user: Person) {
        nameLbl.text = user.name
        ageLbl.text = "\(user.age)"
        createAtLbl.text = "\(user.createAt ?? Date())"
    }
}
