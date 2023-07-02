//
//  cell.swift
//  ContackApp
//
//  Created by Abdusamad Mamasoliyev on 12/05/23.
//

import UIKit

class cell: UITableViewCell {

    @IBOutlet weak var conteneirView: UIView!
    @IBOutlet weak var boshLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var surnameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var boshImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        allRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func allRadius() {
        boshLbl.layer.cornerRadius = 25
        boshLbl.clipsToBounds = true
        conteneirView.layer.cornerRadius = 10
        boshImage.layer.cornerRadius = 25
    }
    func updateCell(contact: Obyekt) {
        
        nameLbl.text = contact.name
        surnameLbl.text =  contact.surname
        conteneirView.backgroundColor = UIColor.systemGray6
        categoryLbl.text = contact.category
        
        if let imageData = contact.img {
            
            let image = UIImage(data: imageData)
            boshImage.image = image
            boshImage.isHidden = false
            boshLbl.isHidden = true
        }else {
            boshImage.isHidden = true
            boshLbl.isHidden = false
            boshLbl.text = "\(contact.name.first!)"
        }
        switch contact.category {
        case "Relative":
            boshLbl.backgroundColor = .blue
        case "Classmate":
            boshLbl.backgroundColor = .systemMint
        case "Groupmate":
            boshLbl.backgroundColor = .brown
        case "Office":
            boshLbl.backgroundColor = .purple
        case "Personal":
            boshLbl.backgroundColor = .systemOrange
        default:
            boshLbl.backgroundColor = .systemCyan
        }
        selectionStyle = .none
    }
}
