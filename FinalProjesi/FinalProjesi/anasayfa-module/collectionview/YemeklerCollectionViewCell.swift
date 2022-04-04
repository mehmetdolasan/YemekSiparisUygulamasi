//
//  YemeklerCollectionViewCell.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 24.03.2022.
//

import UIKit

class YemeklerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var yemekImage: UIImageView!
    @IBOutlet weak var yemekAdLabel: UILabel!
    @IBOutlet weak var yemekFiyatLabel: UILabel!
    
    var cellToAnasayfaVC : YemeklerCollectionViewCellToAnasayfaVCProtocol?
    var indexPath : IndexPath?
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        cellToAnasayfaVC?.butonaTiklandi(indexPath: indexPath!)
    }
}
