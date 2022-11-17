//
//  StudentTableViewCell.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//
import Foundation
import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
