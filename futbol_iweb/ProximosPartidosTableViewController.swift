//
//  ProximosPartidosTableViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 16/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//


import UIKit

class ProximosPartidosTableViewController: UITableViewController {
    
    let proximoPartidoCell : PartidosTableViewCell? = nil
    var proximosPartidos = [[String:Any]]()
    var imagesLocal = [String:UIImage]()
    var imagesVisitante = [String:UIImage]()
    var imageLiga : UIImage?
    var idLiga: String?
    var jornada: Int = 0
    
    fileprivate let API_FUTBOL_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProximosPartidos()
        print("La jornada a jugar es:\(self.jornada)")
        self.title = "PRÓXIMOS PARTIDOS"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imagesLocal=[:]
        imagesVisitante=[:]
    }
    
    func downloadProximosPartidos() {
        let query = "req=matchs&league=\(self.idLiga!)&round=\(self.jornada)"
        let urlClasificacion = "\(API_FUTBOL_URL)\(query)"
        
        let url = URL(string: urlClasificacion)
        print(url)
        
        let cola = DispatchQueue(label: "Descargando próximos partidos")
        cola.async {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            if let data = try? Data(contentsOf: url!){
                print("He entrado al if de descargar los datos de proximos partidos y lo he hecho")
                do {
                    if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any] {
                        print(dic)
                        if let dic2 = dic["match"] as? [[String:Any]]{
                            print(dic2)
                            self.proximosPartidos = dic2
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return proximosPartidos.count
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
        cell?.fechaLabel?.text = ""
        cell?.imagenLiga.image = imageLiga
        
        let partido = self.proximosPartidos[indexPath.row]
        
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
        if let fechaPartido = partido["date"] as? String{
            cell?.fechaLabel?.text = fechaPartido
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
}

