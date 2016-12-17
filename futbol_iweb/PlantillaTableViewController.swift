//
//  PlantillaTableViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 17/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class PlantillaTableViewController: UITableViewController {

    var plantilla = [[String:Any]]()
    var nombreEquipo : String?
    var imagesJugadores = [String:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Plantilla \(nombreEquipo!)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plantilla.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell jugador", for: indexPath)
        
        cell.textLabel?.text = ""
        cell.imageView?.image = nil
        
        let jugador = self.plantilla[indexPath.row]
        if let nombreJugador = jugador["nick"] as? String{
            cell.textLabel?.text = nombreJugador
        }
        if let imagenUrl = jugador["image"] as? String {
            if let imagenJugador = imagesJugadores[imagenUrl] {
                cell.imageView?.image = imagenJugador
            } else {
                if let url = URL(string: imagenUrl){
                    if let data = try? Data(contentsOf: url){
                        if let imagenJugador = UIImage(data: data) {
                            self.imagesJugadores[imagenUrl] = imagenJugador
                            cell.imageView?.image = imagenJugador
                        }
                    }
                }
            }
        }

        return cell
    }
}
