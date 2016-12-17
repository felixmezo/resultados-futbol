//
//  LigasTableViewController.swift
//  futbol
//
//  Created by Felix Mezo on 14/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class LigasTableViewController: UITableViewController {
    
    var ligas = [[String:Any]]()
    var images = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLigas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Descargar Ligas
    
    private func downloadLigas(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
         let url = URL(string: "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&req=leagues&top=1&year=2017&limit=30")
            
            print(url)
        
        guard let data = try? Data(contentsOf: url!) else {
            print("Error: no se han podido descargar los datos.")
            return
        }
        
        do {
            if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:[[String:Any]]] {
                print(dic)
                if let dic2 = dic["league"] {
                    self.ligas = dic2
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ligas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda liga", for: indexPath)
        
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = nil
        
        let nombre1 = self.ligas[indexPath.row]
        if let nombre2 = nombre1["name"] as? String{
            cell.textLabel?.text=nombre2
        }
        if let year = nombre1["year"] as? String {
            cell.detailTextLabel?.text = year
        }
        if let imagenUrl = nombre1["flag"] as? String {
            if let image = images[imagenUrl] {
                cell.imageView?.image = image
            } else {
                if let url = URL(string: imagenUrl){
                    if let data = try? Data(contentsOf: url){
                        if let image = UIImage(data: data) {
                            // Guardar la imagen
                            self.images[imagenUrl] = image
                            cell.imageView?.image = image

                            // Actualizar la celda
                            //self.tableView.reloadRows(at: [indexPath], with: .fade)
                              
                            }
                    }
                }
            }
            }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "cell to info":
            if let pvc = segue.destination as? InfoViewController {
                let cell = sender as! UITableViewCell
                if let ip = tableView.indexPath(for: cell) {
                    let dic = ligas[ip.row] //[String:Any]
                        if let nombre = dic["name"] as? String {
                            pvc.ligaMarcada = nombre
                        }
                        if let imagenUrl = dic["flag"] as? String {
                            if let image = images[imagenUrl] {
                                pvc.imagenLiga = image
                            }
                        }
                        if let idLiga = dic["id"] as? String {
                            print("El ID de la liga es:", idLiga)
                            pvc.idLiga = idLiga
                        }
                        if let jornada = dic["current_round"] as? String {
                            if let jornadaInt = Int(jornada){
                                print("La última jornada jugada es:\(jornadaInt)")
                                pvc.jornada = jornadaInt+1
                            }
                        }

                    }
            }
        default:
            break
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

