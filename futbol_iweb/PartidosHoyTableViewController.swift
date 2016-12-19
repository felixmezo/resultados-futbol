//
//  PartidosHoyTableViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 16/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class PartidosHoyTableViewController: UITableViewController {

    let partidosHoyCell : PartidosTableViewCell? = nil
    var partidosHoy = [[String:Any]]()
    var imagesLocal = [String:UIImage]()
    var imagesVisitante = [String:UIImage]()
    var imagesLiga = [String:UIImage]()
    var fechaHoy : String = ""
    
    fileprivate let API_FUTBOL_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&"

    let session = URLSession(configuration: URLSessionConfiguration.default)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodayDate()
        downloadPartidosHoy()
        self.title = "PARTIDOS DE HOY"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imagesLocal=[:]
        imagesVisitante=[:]
    }
    
    func downloadPartidosHoy() {
        let query = "req=matchsday&top=1"
        let urlClasificacion = "\(API_FUTBOL_URL)\(query)"
        
        let url = URL(string: urlClasificacion)
        print(url)
        
        let cola = DispatchQueue(label: "Descargando partidos de hoy")
        cola.async {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            let task = self.session.downloadTask(with: url!){( location: URL?,
                                                               response: URLResponse?,
                                                               error: Error?) in
                if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                    if let data = try? Data(contentsOf: url!){
                        print("He entrado al if de descargar los datos de partidos de hoy y lo he hecho")
                        do {
                            if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any] {
                                print(dic)
                                if let dic2 = dic["matches"] as? [[String:Any]]{
                                    print(dic2)
                                    self.partidosHoy = dic2
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }catch let err  {
                            print("No puedo sacar el JSON:", (err as NSError).localizedDescription)
                            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "Ni idea de lo que esta pasando.")
                        }
                    }else {
                        print("Error: no se han podido descargar los datos.")
                        return
                    }
                }
            }
            task.resume()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return partidosHoy.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partidos cell", for: indexPath) as? PartidosTableViewCell
        
        cell?.nombreLocal?.text = ""
        cell?.nombreVisitante?.text = ""
        cell?.imagenLocal.image = nil
        cell?.imagenVisitante.image = nil
        cell?.horaLabel?.text = ""
        cell?.ligaLabel?.text = ""
        cell?.imagenLiga?.image = nil
        cell?.fechaLabel2?.text = self.fechaHoy
        
        let partido = self.partidosHoy[indexPath.row]
        
        if let nombreLocal = partido["local"] as? String{
            cell?.nombreLocal?.text = nombreLocal
        }
        if let nombreVisitante = partido["visitor"] as? String{
            cell?.nombreVisitante?.text = nombreVisitante
        }
        if let hora = partido["hour"] as? String{
            if let minutos = partido["minute"] as? String{
                cell?.horaLabel?.text = "\(hora):\(minutos)"
            }
        }
        if let liga = partido["competition_name"] as? String{
            cell?.ligaLabel?.text = liga
        }
        if let imagenLigaUrl = partido["cflag"] as? String {
            if let banderaLiga = self.imagesLiga[imagenLigaUrl] {
                cell?.imagenLiga.image = banderaLiga
            } else {
                if let URL_liga = URL(string: imagenLigaUrl){
                    if let data = try? Data(contentsOf: URL_liga){
                        if let imageLiga = UIImage(data: data) {
                            // Guardar la imagen
                            self.imagesLiga[imagenLigaUrl] = imageLiga
                            cell?.imagenLiga.image = imageLiga
                            
                            // Actualizar la celda
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                    }
                }
            }
        }
        if let imagenLocalUrl = partido["local_shield"] as? String {
            if let escudoLocal = self.imagesLocal[imagenLocalUrl] {
                cell?.imagenLocal.image = escudoLocal
            } else {
                if let URL_local = URL(string: imagenLocalUrl){
                    if let data = try? Data(contentsOf: URL_local){
                        if let imageLocal = UIImage(data: data) {
                            // Guardar la imagen
                            self.imagesLocal[imagenLocalUrl] = imageLocal
                            cell?.imagenLocal.image = imageLocal

                            // Actualizar la celda
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                    }
                }
            }
        }
        if let imagenVisitanteUrl = partido["visitor_shield"] as? String {
            if let escudoVisitante = self.imagesVisitante[imagenVisitanteUrl] {
                cell?.imagenLocal.image = escudoVisitante
            } else {
                if let URL_visitante = URL(string: imagenVisitanteUrl){
                    if let data = try? Data(contentsOf: URL_visitante){
                        if let imageVisitante = UIImage(data: data) {
                            // Guardar la imagen
                            self.imagesVisitante[imagenVisitanteUrl] = imageVisitante
                            cell?.imagenVisitante.image = imageVisitante
                            
                            // Actualizar la celda
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                    }
                }
            }
        }
        return cell!
    }
    
    func getTodayDate(){
        let date = Date()
        let calendar = Calendar.current
        let mes = calendar.component(.month, from: date)
        let dia = calendar.component(.day, from: date)
        let año = calendar.component(.year, from: date)
        print("fecha = \(dia)-\(mes)-\(año)")
        self.fechaHoy = "\(año)/\(mes)/\(dia)"
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
