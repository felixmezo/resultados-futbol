//
//  DetalleEquipoViewController.swift
//  futbol_iweb
//
//  Created by Felix Mezo on 16/12/16.
//  Copyright © 2016 Felix Mezo. All rights reserved.
//

import UIKit

class DetalleEquipoViewController: UIViewController {
    
    var idEquipo: String?
    var imagesEscudo = [String:UIImage]()
    var imagesEstadio = [String:UIImage]()
    var nombreEquipoLargo: String = ""
    var nombreEquipoCorto: String = ""
    var escudo: UIImage?
    var bandera: UIImage?
    var entrenador: String = ""
    var estadio: String = ""
    var estadioFoto: UIImage? = nil
    var plantilla = [[String:Any]]()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var escudoImagen: UIImageView!
    @IBOutlet weak var banderaImagen: UIImageView!
    @IBOutlet weak var nombreEntrenador: UILabel!
    @IBOutlet weak var nombreEstadio: UILabel!
    @IBOutlet weak var estadioImagen: UIImageView!
    
    fileprivate let API_FUTBOL_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=833e3ee072e13520e85973b61b49f1c3&tz=Europe/Madrid&format=json&"

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadDetalleEquipo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadDetalleEquipo(){
        let query = "req=team&id=\(idEquipo!)"
        let urlClasificacion = "\(API_FUTBOL_URL)\(query)"
        
        let url = URL(string: urlClasificacion)
        print(url)
        
        let cola = DispatchQueue(label: "Descargando detalle de equipos")
        cola.async {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            let task = self.session.downloadTask(with: url!) {( location: URL?,
                                                               response: URLResponse?,
                                                               error: Error?) in
                if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                    if let data = try? Data(contentsOf: url!){
                        print("He entrado al if de descargar detalles de equipos y lo he hecho")
                        do {
                            if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any] {
                                print(dic)
                                if let equipo = dic["team"] as? [String:Any]{
                                    if let nombreLargo = equipo["fullName"] as? String {
                                        DispatchQueue.main.async {
                                            self.nombreEquipoLargo = nombreLargo
                                            self.nombreCompleto?.text = self.nombreEquipoLargo
                                        }
                                    }
                                    if let nombreCorto = equipo["nameShow"] as? String{
                                        DispatchQueue.main.async {
                                            self.nombreEquipoCorto = nombreCorto
                                            self.title = self.nombreEquipoCorto
                                        }
                                    }
                                    if let escudoUrl = equipo["shield"] as? String {
                                        if let imageEscudo = self.imagesEscudo[escudoUrl] {
                                            DispatchQueue.main.async {
                                                self.escudo = imageEscudo
                                                self.escudoImagen?.image = self.escudo
                                            }
                                        } else {
                                            if let url = URL(string: escudoUrl){
                                                if let data = try? Data(contentsOf: url){
                                                    if let imageEscudoDescargada = UIImage(data: data) {
                                                        DispatchQueue.main.async {
                                                            self.imagesEscudo[escudoUrl] = imageEscudoDescargada
                                                            self.escudo = imageEscudoDescargada
                                                            self.escudoImagen?.image = self.escudo
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if let entrenador = equipo["managerNow"] as? String {
                                        DispatchQueue.main.async {
                                            self.entrenador = entrenador
                                            self.nombreEntrenador?.text = self.entrenador
                                        }
                                    }
                                    if let estadio = equipo["stadium"] as? String {
                                        DispatchQueue.main.async {
                                            self.estadio = estadio
                                            self.nombreEstadio?.text = self.estadio
                                        }
                                    }
                                    if let estadioUrl = equipo["img_stadium"] as? String {
                                        if let imageEstadioYaDescargada = self.imagesEstadio[estadioUrl] {
                                            DispatchQueue.main.async {
                                                self.estadioFoto = imageEstadioYaDescargada
                                                self.estadioImagen?.image = self.estadioFoto
                                            }
                                        } else {
                                            if let url = URL(string: estadioUrl){
                                                if let data = try? Data(contentsOf: url){
                                                    if let imageEstadioDescargada = UIImage(data: data) {
                                                        DispatchQueue.main.async {
                                                            self.imagesEstadio[estadioUrl] = imageEstadioDescargada
                                                            self.estadioFoto = imageEstadioDescargada
                                                            self.estadioImagen?.image = self.estadioFoto
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if let plantilla = equipo["squad"] as? [[String:Any]]{
                                        DispatchQueue.main.async {
                                            self.plantilla = plantilla
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.banderaImagen?.image = self.bandera
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "detalle to plantilla":
            if let pvc = segue.destination as? PlantillaTableViewController {
                pvc.plantilla = self.plantilla
                pvc.nombreEquipo = self.nombreEquipoCorto
            }
        default:
            break
        }
    }

}
