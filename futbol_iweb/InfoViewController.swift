//
//  InfoViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 15/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var ligaMarcada : String?
    var imagenLiga : UIImage?
    var idLiga : String?
    var jornada: Int=0
    
    @IBOutlet weak var ligaLabel: UILabel!
    @IBOutlet weak var imageLiga: UIImageView!
    @IBOutlet weak var jornadaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ligaLabel?.text = ligaMarcada
        imageLiga?.image = imagenLiga
        jornadaLabel?.text = "\(jornada)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "info to clasificacion":
            if let pvc = segue.destination as? ClasificacionTableViewController {
                pvc.ligaMarcada = self.ligaMarcada
                pvc.imagenLiga = self.imagenLiga
                pvc.idLiga = self.idLiga
            }
        case "info to prox partidos":
            if let pvc = segue.destination as? ProximosPartidosTableViewController {
                pvc.idLiga = self.idLiga
                pvc.jornada = self.jornada
                pvc.imageLiga = self.imagenLiga
                }
        case "info to listado":
            if let pvc = segue.destination as? ListadoEquiposTableViewController {
                pvc.ligaMarcada = self.ligaMarcada
                pvc.idLiga = self.idLiga
                pvc.imagenLiga = self.imagenLiga
            }
        default:
            break
        }
    }
}
