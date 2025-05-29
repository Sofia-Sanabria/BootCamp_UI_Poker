//
//  NewViewController.swift
//  UI_Poker
//
//  Created by Bootcamp on 2025-05-28.
//

import UIKit

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mejoresPuntajes: [JugadorPuntaje] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Cargar los mejores puntajes actualizados cada vez que aparece
        mejoresPuntajes = puntajes
            .sorted { $0.puntaje > $1.puntaje } // Ordenar de mayor a menor
            .prefix(5) // Tomar solo los primeros 5
            .map { $0 }
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// El extension sirve para agregar mas metodos a nuestras clases
extension NewViewController {

    // Cantidad de puntajes guardados
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mejoresPuntajes.count
        }

    //  Se llama cada vez que el tableView necesita una Celda para cada jugador, nombre y puntaje.
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

