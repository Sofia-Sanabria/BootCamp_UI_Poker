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
    var jugadorText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Borrar TextField
        nombreTextField.clearButtonMode = .whileEditing
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        confirmarTextField.clearButtonMode = .whileEditing
    
        nombreTextField.text = jugadorText
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
        
        // Validacion: ningun campo vacio
        guard let nombre = nombreTextField.text, !nombre.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmar = confirmarTextField.text, !confirmar.isEmpty else {
            mostrarAlerta(mensaje: "Todos los campos son obligatorios.")
            return
        }
        
        // Validacion de contraseñas
        guard password == confirmar else {
            mostrarAlerta(mensaje: "Las contraseñas no coinciden.")
            return
        }
        
        var usuarios = obtenerUsuariosRegistrados()
        
        // Validar nombre de usuario unico
        if usuarios.contains(where: { $0.nombre == nombre }) {
            mostrarAlerta(mensaje: "El nombre de usuario ya está en uso.")
            return
        }
        
        // Si pasa todas las validaciones, registrar usuario
        let nuevoUsuario = Usuario(nombre: nombre, email: email, contrasena: password)
        usuarios.append(nuevoUsuario)
        guardarUsuarios(usuarios)
        
        mostrarAlerta(mensaje: "¡Registro exitoso!")
        
        // Limpiar campos
        nombreTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmarTextField.text = ""
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
    
    // Obtener usuarios registrados desde UserDefaults
    func obtenerUsuariosRegistrados() -> [Usuario] {
        if let data = UserDefaults.standard.data(forKey: "usuariosRegistrados"),
           let usuarios = try? JSONDecoder().decode([Usuario].self, from: data) {
            return usuarios
        }
        return []
    }
    
    // Guardar lista de usuarios en UserDefaults
    func guardarUsuarios(_ usuarios: [Usuario]) {
        if let data = try? JSONEncoder().encode(usuarios) {
            UserDefaults.standard.set(data, forKey: "usuariosRegistrados")
        }
    }
}
