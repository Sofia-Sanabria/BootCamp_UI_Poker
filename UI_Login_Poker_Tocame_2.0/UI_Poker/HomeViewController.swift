//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  Primer ViewController UI_Poker
//
//  Created by Bootcamp on 2025-05-26.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {

    // TextField para elegir el juego desde un PickerView
    @IBOutlet weak var juegosTextField: UITextField!
    
    @IBOutlet weak var bienvenidoLabel: UINavigationItem!
    
    @IBOutlet weak var jugadorLabel: UILabel!
    
    @IBOutlet weak var jugarButton: UIButton!
    
    @IBOutlet weak var puntajesOutlet: UIButton!
    
    @IBOutlet weak var ayudaOutlet: UIButton!
    
    @IBOutlet weak var ayudaTextView: UITextView!
    
    // Lista de juegos disponibles para el PickerView
    let juegos = ["Poker", "Tócame", "Sofi"]
    
    // Diccionario de instrucciones que se veran en Ayuda
    let instrucciones: [String: String] = [
        "Poker": """
        Presiona el botón "Barajar" para repartir cinco cartas aleatorias. Tu objetivo es formar una mano ganadora según las reglas clásicas del póker, como pareja, doble pareja, trío, escalera, color, full, póker o escalera de color. 
        """,
        
        "Tócame": """
        El objetivo es tocar al osito que aparece en pantalla antes de que termine el tiempo. El osito aparecerá en distintos lugares de la pantalla de forma aleatoria. Cada vez que logres tocarlo a tiempo, sumarás un punto. 
        """
    ]
    
    // PickerView que se muestra al tocar el TextField
    var pickerView = UIPickerView()
    
    // Variable que almacena el nombre del jugador
    var jugadorText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Redondear bordes de los elementos visuales
        juegosTextField.layer.cornerRadius = 20
        jugarButton.layer.cornerRadius = 20
        puntajesOutlet.layer.cornerRadius = 20
        ayudaOutlet.layer.cornerRadius = 20

        // Ocultar el TextView de ayuda al inicio
        ayudaTextView.isHidden = true

        // Mostrar el nombre del jugador en la etiqueta
        jugadorLabel.text = jugadorText

        // Asignar el PickerView como input del TextField
        pickerView.delegate = self
        pickerView.dataSource = self
        juegosTextField.inputView = pickerView
        juegosTextField.textAlignment = .center

        // Agregar gesto para cerrar el PickerView al tocar fuera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
    }

    // Accion para cerrar el PickerView o teclado
    @objc func dismissPicker() {
        view.endEditing(true)
    }

    // Accion para navegar a la vista de puntajes
    @IBAction func puntajesButton(_ sender: UIButton) {
        guard let puntajesVC = storyboard?.instantiateViewController(withIdentifier: "puntajesID") as? TablaViewController else { return }
        puntajesVC.cantidadTop = 5
        puntajesVC.nombreJugador = jugadorLabel.text ?? ""
        show(puntajesVC, sender: nil)
    }

    // Accion del boton Ayuda para mostrar instrucciones del juego seleccionado
    @IBAction func ayudaButton(_ sender: UIButton) {
        // Verificar que el campo de Juego no este vacio
        guard let juegoSeleccionado = juegosTextField.text, !juegoSeleccionado.isEmpty else {
            ayudaTextView.text = "Selecciona un juego para ver la ayuda."
            ayudaTextView.isHidden = false
            return
        }

        // Mostrar el texto de ayuda correspondiente
        if let texto = instrucciones[juegoSeleccionado] {
            ayudaTextView.text = texto
        } else {
            ayudaTextView.text = "No hay instrucciones disponibles para este juego."
        }
        ayudaTextView.isHidden = false // Mostrar el TextView
    }

    // Accion al presionar el botón "Jugar"
    @IBAction func playGame(_ sender: UIButton) {
        guard let juegoSeleccionado = juegosTextField.text else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Se dirige al juego de Poker
        if juegoSeleccionado == "Poker" {
            if let pokerVC = storyboard.instantiateViewController(withIdentifier: "pokerVC") as? PokerViewController {
                pokerVC.jugador1Text = jugadorLabel.text
                pokerVC.jugador2Text = "ChatGPT"
                show(pokerVC, sender: nil)
            }
        // Se dirige al juego de Tocame
        } else if juegoSeleccionado == "Tócame" {
            if let touchVC = storyboard.instantiateViewController(withIdentifier: "touchButtonVC") as? TocameViewController {
                touchVC.jugador1Text = jugadorLabel.text ?? ""
                show(touchVC, sender: nil)
            }
        } else {
            // Muestra un alerta
            let alert = UIAlertController(title: "Error", message: "Juego no implementado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// La extension sirve para agregar mas metodos a nuestras clases ordenadamente
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // Una sola columna en el PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Cantidad de juegos disponibles
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return juegos.count
    }

    // Mostrar cada nombre de juego en el Picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return juegos[row]
    }

    // Al seleccionar un juego del Picker, se actualiza el TextField
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let juego = juegos[row]
        juegosTextField.text = juego
        juegosTextField.resignFirstResponder()
        ayudaTextView.isHidden = true
        ayudaTextView.text = " "
    }
}
