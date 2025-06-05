//
//  NewViewController.swift
//  UI_Poker
//
//  Created by Bootcamp on 2025-05-28.
//

import UIKit

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Arreglo que contiene los mejores puntajes
    var mejoresPuntajes: [ScoreRequest] = []
    
    
    var cantidadTop: Int = 5 // valor de prefijo por defecto
    var nombreJugador: String = "" // Nombre el jugador
    var mostrarSoloJugador = false // Muestra los puntajes
    
    // Cargar puntaje desde la API
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarSoloJugador = false
        cargarPuntajesDesdeAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Elimina el historial de puntajes
        // UserDefaults.standard.removeObject(forKey: "historial")
        
        // Asignar el controlador de datos
        tableView.dataSource = self
        tableView.delegate = self
        
        // Cargar Puntajes
        cargarPuntajesDesdeAPI()
    }
    
    func cargarPuntajesDesdeAPI() {
        
        // Verificar que haya un token guardado en UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("No se encontró sesión activa")
                return
            }
        
        // Llamar al método de APIService que obtiene los puntajes del juego "tocame"
        APIService.shared.obtenerPuntajes(gameID: "1", token: token) { [weak self] result in
            // Ejecutar la actualización de la interfaz en el hilo principal
            DispatchQueue.main.async {
                switch result {
                case .success(let todosLosPuntajes):
                    
                    // Mostrar los puntajes del jugador que inicio sesion
                    if self?.mostrarSoloJugador == true {
                        self?.mejoresPuntajes = todosLosPuntajes
                            .filter { $0.nombre == self?.nombreJugador } // Filtrar por nombre exacto
                            .sorted { $0.score > $1.score }
                            .prefix(self?.cantidadTop ?? 5)
                            .map { $0 }
                    } else {
                        // Motrar los puntajes globale
                        self?.mejoresPuntajes = todosLosPuntajes
                            .sorted { $0.score > $1.score }
                            .prefix(self?.cantidadTop ?? 5)
                            .map { $0 }
                    }
                    
                    print("Buscando puntajes del jugador: \(self?.nombreJugador ?? "Sin nombre")")

                    
                    // Actualizar la tabla con los nuevos datos
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error al obtener puntajes: \(error.msg)")
                }
            }
        }
    }
}
    
    
    // El extension sirve para agregar mas metodos a nuestras clases
extension TablaViewController {
    
    // Cantidad de puntajes guardados
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mejoresPuntajes.count
    }
    
    // Se llama cada vez que el tableView necesita una Celda para cada jugador, nombre y puntaje.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Se define un identificador de celda.
        let cellIdentifier = "celdaConDetalle"
        
        // Actualiza la celda con el mejor puntaje
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        // Se crea una celda nueva si no hay ninguna disponible
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        
        // Se obtiene el mejor jugador
        let entrada = mejoresPuntajes[indexPath.row]
        
        // Se asignan los textos a los labels
        cell?.textLabel?.text = entrada.nombre ?? "Jugador"
        cell?.detailTextLabel?.text = "\(entrada.score) pts - \(entrada.date)"
        
        return cell!
    }
    // Titulo de la tabla
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mejores puntajes"
    }
}

