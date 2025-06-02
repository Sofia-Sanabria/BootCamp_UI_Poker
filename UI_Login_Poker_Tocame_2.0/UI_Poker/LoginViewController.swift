//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  ViewController de Inicio de Sesion Navegacion
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var inicioSesionLabel: UILabel!
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var iniciarSesionOutlet: UIButton!
    
    @IBOutlet weak var registrarseOutlet: UIButton!
    
    @IBOutlet weak var puntajesOutlet: UIButton!
    
    
    // Boton que contiene una accion para iniciar seccion una vez pasado todas las validaciones
    @IBAction func iniciarSesionButton(_ sender: UIButton) {
        guard let nombre = nombreTextField.text,
              let contrasena = passwordTextField.text else { return }

        let usuarios = cargarUsuarios()
        
        // Verificar si los campos estan completos
        if !(nombreTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true) {
            // Verificar si el usuario existe y la contraseña es correcta
            if let usuario = usuarios.first(where: { $0.nombre == nombre }) {
                if usuario.contrasena == contrasena {
                    // Navegar al View Controller del Home
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let home = storyboard.instantiateViewController(withIdentifier: "loginVC") as? HomeViewController {
                        home.jugadorText = nombre
                        show(home, sender: nil)
                    }
                    
                } else {
                    mostrarAlerta(titulo: "Error", mensaje: "Contraseña incorrecta.")
                }
            } else {
                mostrarAlerta(titulo: "Error", mensaje: "Usuario no registrado.")
            }
        } else {
            mostrarAlerta(titulo: "Error", mensaje: "Todos los campos son obligatorios.")
        }
    }
        
    // Boton que contiene una accion para ir a la seccion de registro
    @IBAction func registrarseButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registro = storyboard.instantiateViewController(withIdentifier: "Registro") as? RegistroViewController {
            registro.jugadorText = nombreTextField.text ?? ""
            show(registro, sender: nil)
        }
    }
    
    // Boton que contiene una accion para mostrar una tabla con los mejores puntajes
    @IBAction func topMejoresButton(_ sender: UIButton) {
        guard let puntajesVC = storyboard?.instantiateViewController(withIdentifier: "puntajesID") as? TablaViewController else { return }
        puntajesVC.cantidadTop = 10
        puntajesVC.mostrarSoloJugador = false
        show(puntajesVC, sender: nil)
    }
    
    // Funcion de alerta reutilizable
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    // Funcion para cargar usuarios desde UserDefaults
    func cargarUsuarios() -> [Usuario] {
        if let datos = UserDefaults.standard.data(forKey: "usuariosRegistrados"),
           let usuarios = try? JSONDecoder().decode([Usuario].self, from: datos) {
            return usuarios
        }
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Borrar TextField
        nombreTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        
        // Ocultar caracteres del campo de contraseña
        passwordTextField.isSecureTextEntry = true
        
        // Redondear Bordes de componentes
        nombreTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        iniciarSesionOutlet.layer.cornerRadius = 20
        registrarseOutlet.layer.cornerRadius = 20
        puntajesOutlet.layer.cornerRadius = 20
    }
}

