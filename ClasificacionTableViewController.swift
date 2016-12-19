//
//  ClasificacionTableViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 15/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class ClasificacionTableViewController: UITableViewController {
    
    var equipos = [[String:Any]]()
    var images = [String:UIImage]()
    var ligaMarcada : String?
    var imagenLiga : UIImage?
    var idLiga: String?
    
    fileprivate let API_FUTBOL_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&"
    
    let session = URLSession(configuration: URLSessionConfiguration.default)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadClasificacion()
        
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
    
    func downloadClasificacion(){
        let query = "req=tables&league=\(idLiga!)&group=all"
        let urlClasificacion = "\(API_FUTBOL_URL)\(query)"
        
        let url = URL(string: urlClasificacion)
        print(url)
        
        let cola = DispatchQueue(label: "Descargando clasificacion")
        cola.async {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            let task = self.session.downloadTask(with: url!) {(location: URL?,
                                                               response: URLResponse?,
                                                               error: Error?) in
                if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                    if let data = try? Data(contentsOf: url!){
                        print("He entrado al if de descargar la clasificacion y lo he hecho")
                        do {
                            if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:[[String:Any]]] {
                                print(dic)
                                if let dic2 = dic["table"] {
                                    self.equipos = dic2
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
        return equipos.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda clasificacion", for: indexPath)
        
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = nil
        
        let nombre1 = self.equipos[indexPath.row]
        if let nombre2 = nombre1["team"] as? String{
            cell.textLabel?.text="\(indexPath.row + 1)-\(nombre2)"
        }
        if let puntos = nombre1["points"] as? String {
            cell.detailTextLabel?.text = "\(puntos) pts"
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
}
