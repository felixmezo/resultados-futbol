//
//  ListadoEquiposTableViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 16/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class ListadoEquiposTableViewController: UITableViewController {
    
    var imagenLiga : UIImage?
    
    var equipos = [[String:Any]]()
    var images = [String:UIImage]()
    var ligaMarcada : String?
    var idLiga: String?
    var idEquipo: String?
    
    fileprivate let API_FUTBOL_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadListadoEquipos()
        self.title = ligaMarcada
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        images=[:]
        // Dispose of any resources that can be recreated.
    }
    
    func downloadListadoEquipos(){
        let query = "req=teams&league=\(idLiga!)&group=all"
        let urlClasificacion = "\(API_FUTBOL_URL)\(query)"
        
        let url = URL(string: urlClasificacion)
        print(url)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        guard let data = try? Data(contentsOf: url!) else {
            print("Error: no se han podido descargar los datos.")
            return
        }
        
        do {
            if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:[[String:Any]]] {
                print(dic)
                if let dic2 = dic["team"] {
                    self.equipos = dic2
                    tableView.reloadData()
                }
            }
        }catch let err  {
            print("No puedo sacar el JSON:", (err as NSError).localizedDescription)
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "Ni idea de lo que esta pasando.")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return equipos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda listado", for: indexPath)
        
        cell.textLabel?.text = ""
        cell.imageView?.image = nil
        
        let nombre1 = self.equipos[indexPath.row]
        if let nombre2 = nombre1["nameShow"] as? String{
            cell.textLabel?.text = nombre2
        }
        if let imagenUrl = nombre1["shield"] as? String {
            if let image = images[imagenUrl] {
                cell.imageView?.image = image
            } else {
                if let url = URL(string: imagenUrl){
                    if let data = try? Data(contentsOf: url){
                        if let image = UIImage(data: data) {
                            // Guardar la imagen
                            self.images[imagenUrl] = image
                            cell.imageView?.image = image
                        }
                    }
                }
            }
        }
        
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "listado to detalle":
            if let pvc = segue.destination as? DetalleEquipoViewController {
                let cell = sender as! UITableViewCell
                if let ip = tableView.indexPath(for: cell) {
                    let dic = equipos[ip.row] //[String:Any]
                    if let identificador = dic["id"] as? String {
                        pvc.idEquipo = identificador
                        pvc.bandera = self.imagenLiga
                    }
                }
            }
        default:
            break
        }
    }

}
