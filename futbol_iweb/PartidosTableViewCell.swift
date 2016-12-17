//
//  PartidosTableViewCell.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 16/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class PartidosTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenVisitante: UIImageView!
    @IBOutlet weak var imagenLocal: UIImageView!
    @IBOutlet weak var nombreLocal: UILabel!
    @IBOutlet weak var nombreVisitante: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var ligaLabel: UILabel!
    @IBOutlet weak var imagenLiga: UIImageView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var fechaLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
