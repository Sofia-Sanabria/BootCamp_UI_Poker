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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var iniciarSesionOutlet: UIButton!
    
    @IBOutlet weak var registrarseOutlet: UIButton!
    
    @IBOutlet weak var puntajesOutlet: UIButton!
    
    
    // Boton que contiene una accion para iniciar seccion una vez pasado todas las validaciones
    @IBAction func iniciarSesionButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        // Verificar si los campos están completos
        if !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true) {
            
            // Llamada a la API para intentar login con email y contraseña
            APIService.shared.login(email: email, password: password) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                        
                    // Guardar token y userID para uso futuro
                    UserDefaults.standard.set(data.token, forKey: "authToken")
                    UserDefaults.standard.set(data.userID, forKey: "userID")
                    
                    // Extraer el nombre si existe
                    let nombre = data.nombre ?? "Jugador"
                    
                    // Guardar en UserDefaults el nombre
                    UserDefaults.standard.set(nombre, forKey: "nombreJugador")
                    
                    // Navegar al HomeViewController y pasar el nombre
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let home = storyboard.instantiateViewController(withIdentifier: "loginVC") as? HomeViewController {
                        home.jugadorText = nombre
                        self.show(home, sender: nil)
                    }
                        
                case .failure(let error):
                    // Mostrar mensaje de error de Supabase (como "credenciales inválidas")
                    if error.msg.contains("Invalid login credentials") {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Usuario o contraseña incorrectos.")
                    } else {
                        self.mostrarAlerta(titulo: "Error", mensaje: error.msg)
                    }
                }
            }
            
        } else {
            mostrarAlerta(titulo: "Error", mensaje: "Todos los campos son obligatorios.")
        }
    }
    
        
    // Boton que contiene una accion para ir a la seccion de registro
    @IBAction func registrarseButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registro = storyboard.instantiateViewController(withIdentifier: "Registro") as? RegistroViewController {
            registro.emailJugadorText = emailTextField.text ?? ""
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Borrar TextField
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        
        // Ocultar caracteres del campo de contraseña
        passwordTextField.isSecureTextEntry = true
        
        // Redondear Bordes de componentes
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        iniciarSesionOutlet.layer.cornerRadius = 20
        registrarseOutlet.layer.cornerRadius = 20
        puntajesOutlet.layer.cornerRadius = 20
    }
}

