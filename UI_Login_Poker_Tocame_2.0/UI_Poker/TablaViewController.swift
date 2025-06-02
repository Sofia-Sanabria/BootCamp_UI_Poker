//
//  NewViewController.swift
//  UI_Poker
//
//  Created by Bootcamp on 2025-05-28.
//

import UIKit

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Actualizar los puntajes
       if mostrarSoloJugador {
           cargarPuntajesJugador(prefijo: cantidadTop)
       } else {
           cargarMejoresPuntajes(prefijo: cantidadTop)
       }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Elimina el historial de puntajes
        // UserDefaults.standard.removeObject(forKey: "historial")
        
        // Asignar el controlador de datos
        tableView.dataSource = self
        tableView.delegate = self
        
        // Cargar Puntajes
        cargarMejoresPuntajes(prefijo: cantidadTop)
    }

    // Arreglo que contiene los mejores puntajes
    var mejoresPuntajes: [EntradaHistorial] = []
    
    var cantidadTop: Int = 5 // valor de prefijo por defecto
    var nombreJugador: String = "" // Nombre el jugador
    var mostrarSoloJugador = true // Muestra los puntajes

    // Funcion que obtiene los mejores puntajes desde el historial
    func cargarMejoresPuntajes(prefijo: Int) {
        let historial = cargarHistorial()
        
        // Ordenar de mayor a menor puntaje
        let mejores = historial.sorted(by: { $0.puntaje > $1.puntaje }).prefix(prefijo)
        
        // Guardar en la variable
        mejoresPuntajes = Array(mejores)
        
        // Recargar los datos de la tabla
        tableView.reloadData()
    }
    
    // Funcion que obtiene los puntajes de un jugador especifico
    func cargarPuntajesJugador(prefijo: Int) {
        let historial = cargarHistorial()
        
        // Filtrar por nombre del jugador actual
        let filtrado = historial.filter { $0.nombre == nombreJugador }
        
        // Ordenar y obtener los mejores puntajes
        let mejores = filtrado.sorted(by: { $0.puntaje > $1.puntaje }).prefix(prefijo)
        
        mejoresPuntajes = Array(mejores)
        tableView.reloadData()
    }

}

// Funcion que carga el historial de puntajes
func cargarHistorial() -> [EntradaHistorial] {
    // Intentar recuperar los datos codificados del historial
    if let data = UserDefaults.standard.data(forKey: "historial"),
       let historial = try? JSONDecoder().decode([EntradaHistorial].self, from: data) {
        return historial
    }
    return []
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
        let jugador = mejoresPuntajes[indexPath.row]
        
        // Se asignan los textos a los labels
        cell?.textLabel?.text = jugador.nombre
        cell?.detailTextLabel?.text = "\(jugador.puntaje) pts"
        
        return cell!
    }
    // Titulo de la tabla
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mejores puntajes"
    }
}
