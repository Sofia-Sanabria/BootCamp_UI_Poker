//
//  GitHub
//  Elercicio realizado por Sofia Sanabria
//
//  ViewController de Registro Navegacion
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit
import Foundation

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var registroLabel: UILabel!
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmarTextField: UITextField!
    
    @IBOutlet weak var registroButtonOutlet: UIButton!
    
    @IBOutlet weak var inicioOutlet: UIButton!
    
    @IBOutlet weak var registroConstraint: NSLayoutConstraint!
    
    // Variable temporal para traer texto de otra pantalla
    var emailJugadorText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Borrar TextField
        nombreTextField.clearButtonMode = .whileEditing
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        confirmarTextField.clearButtonMode = .whileEditing
    
        emailTextField.text = emailJugadorText
        registroConstraint.constant = 80
        inicioOutlet.isHidden = true
        
        // Redondear Bordes de componentes
        [nombreTextField, emailTextField, passwordTextField, confirmarTextField].forEach {
            $0?.layer.cornerRadius = 20
        }
        registroButtonOutlet.layer.cornerRadius = 20
        inicioOutlet.layer.cornerRadius = 20
    }
    
    // Accion del boton de registro
    @IBAction func registroButton(_ sender: UIButton) {
        
       // Validar campos vacíos
       guard let nombre = nombreTextField.text, !nombre.isEmpty,
             let email = emailTextField.text, !email.isEmpty,
             let password = passwordTextField.text, !password.isEmpty,
             let confirmar = confirmarTextField.text, !confirmar.isEmpty else {
           mostrarAlerta(mensaje: "Todos los campos son obligatorios.")
           return
       }
       
       // Validar contraseñas coincidentes
       guard password == confirmar else {
           mostrarAlerta(mensaje: "Las contraseñas no coinciden.")
           return
       }
       
       // Llamar al método signup de la API
        APIService.shared.signup(nombre: nombre, email: email, password: password) { resultado in
           DispatchQueue.main.async {
               switch resultado {
               case .success():
                   // Registro exitoso
                   self.mostrarAlerta(mensaje: "¡Registro exitoso!")

                   // Limpiar campos
                   self.nombreTextField.text = ""
                   self.emailTextField.text = ""
                   self.passwordTextField.text = ""
                   self.confirmarTextField.text = ""

               case .failure(let error):
                   // Mostrar mensaje de error de la API
                   self.mostrarAlerta(mensaje: "Error al registrar: \(error.msg)")
               }
           }
       }
    }
    
    // Accion del boton para ir a Inicio de Sesion
    @IBAction func inicioButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let inicio = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            show(inicio, sender: nil)
        }
    }
    
    // Funcion que muestra una alerta de validación
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "Ok", style: .default) { _ in
            self.inicioOutlet.isHidden = false // Aparece el botón de inicio
            self.registroConstraint.constant = 20 // Se mueve el botón de registro
        }
        alerta.addAction(accionOk)
        self.present(alerta, animated: true)
    }
}
