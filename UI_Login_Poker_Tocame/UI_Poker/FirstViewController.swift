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

class FirstViewController: UIViewController {

    // TextField para elegir el juego desde un PickerView
    @IBOutlet weak var juegosTextField: UITextField!
    
    @IBOutlet weak var bienvenidoLabel: UINavigationItem!
    
    @IBOutlet weak var jugador1Label: UILabel!
    
    @IBOutlet weak var jugador2Label: UILabel!
    
    @IBOutlet weak var jugador1TextField: UITextField!
    
    @IBOutlet weak var jugador2TextField: UITextField!

    @IBOutlet weak var jugarButton: UIButton!
    
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    
    // Lista de juegos disponibles para el PickerView
    let juegos = ["Poker", "Tócame", "Sofi"]
    
    // PickerView que se muestra al tocar el TextField
    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion inicial del boton
        jugarButton.isEnabled = false
        buttonConstraint.constant = 260.7
        
        // Configurar el pickerView como input del TextField
        pickerView.delegate = self
        pickerView.dataSource = self
        juegosTextField.inputView = pickerView
        juegosTextField.textAlignment = .center

        // Para que se cierre el teclado/picker al tocar fuera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Acción para cerrar el pickerView o teclado
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    // Acción que se ejecuta al presionar el botón "Jugar"
    @IBAction func playGame(_ sender: UIButton) {
        
        guard let juegoSeleccionado = juegosTextField.text else { return }

        // Navegar al ViewController correspondiente según el juego seleccionado
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if juegoSeleccionado == "Poker" {
            if let pokerVC = storyboard.instantiateViewController(withIdentifier: "pokerVC") as? SecondViewController {
                // Pasar el texto de TextField al segundo View controller
                pokerVC.jugador1Text = jugador1TextField.text ?? ""
                pokerVC.jugador2Text = jugador2TextField.text ?? ""
                show(pokerVC, sender: nil)
            }
        } else if juegoSeleccionado == "Tócame" {
            if let touchVC = storyboard.instantiateViewController(withIdentifier: "touchButtonVC") as? ThirdViewController {
                // Pasar el texto de TextField al Tercer View controller
                touchVC.jugador1Text = jugador1TextField.text ?? ""
                show(touchVC, sender: nil)
            }
        } else {
            // Si se selecciona otro juego no implementado, mostrar un alert
            let alert = UIAlertController(title: "Error", message: "Juego no implementado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // Funcion para Deshabilitar el boton, mientras los campos de texto esten vacios
    @IBAction func textFieldAction(_ sender: UITextField) {
        if !(jugador1TextField.text?.isEmpty ?? true) || !(jugador2TextField.text?.isEmpty ?? true) {
            jugarButton.isEnabled = true
        } else {
            jugarButton.isEnabled = false
        }
    }
}

// Extension para manejar el PickerView
extension FirstViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Cantidad de columnas en el PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Cantidad de filas en el PickerView 
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return juegos.count
    }
    
    // Titulo que se mostrara en cada fila del PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return juegos[row]
    }
    
    // Accion que se ejecuta al seleccionar un juego del Picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let juego = juegos[row]
        juegosTextField.text = juego
        juegosTextField.resignFirstResponder()
        
        // Mostrar o ocultar campos segun el juego seleccionado
        if juego == "Tócame" {
            jugador1TextField.text = " "
            jugador2Label.isHidden = true
            jugador2TextField.isHidden = true
            jugarButton.isEnabled = false
            buttonConstraint.constant = 200.7
        } else {
            jugador1TextField.text = " "
            jugador2TextField.text = " "
            jugador2Label.isHidden = false
            jugador2TextField.isHidden = false
            jugarButton.isEnabled = false
            buttonConstraint.constant = 260.7
        }
    }
    
    
}
