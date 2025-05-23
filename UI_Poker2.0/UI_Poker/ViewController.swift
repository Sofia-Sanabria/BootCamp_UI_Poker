//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  UI_Poker
//
//  Created by Bootcamp on 2025-05-22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBAction func pokerButton(_ sender: UIButton) {
    
        let nombre1 = jugador1TextField.text ?? "Jugador 1"
        let nombre2 = jugador2TextField.text ?? "Jugador 2"

        let nombreActual = sender.title(for: .normal) ?? "Sin título"

        if nombreActual == "Barajar" {
            sender.setTitle("Volver a Barajar", for: .normal)

            // Ocultar solo el formulario
            formularioStackView.isHidden = true

            // Mostrar cartas del jugador 1
            mostrarCartasJugador1([
                Carta("5H"), Carta("KS"), Carta("KC"), Carta("KD"), Carta("KH")
            ])

            // Mostrar cartas del jugador 2
            mostrarCartasJugador2([
                Carta("AS"), Carta("2S"), Carta("3S"), Carta("4S"), Carta("5S")
            ])

            let resultado1 = analizarMano(jugador: nombre1, cartas: [
                Carta("5H"), Carta("KS"), Carta("KC"), Carta("KD"), Carta("KH")
            ])
            let resultado2 = analizarMano(jugador: nombre2, cartas: [
                Carta("AS"), Carta("2S"), Carta("3S"), Carta("4S"), Carta("5S")
            ])

            let (ganador, jugada) = determinarGanador(j1: resultado1, j2: resultado2)
            mostrarAlertaAnimada(en: self, ganador: ganador, jugada: jugada)

        } else {
            sender.setTitle("Barajar", for: .normal)

            // Mostrar formulario
            formularioStackView.isHidden = false

            // Limpiar TextField
            jugador1TextField.text = ""
            jugador2TextField.text = ""
            
            // Ocultar las cartas
            imagenesStackView.isHidden = true
            j1ImagenesStackView.isHidden = true
            j2ImagenesStackView.isHidden = true
        }
        
    }
    
    
    @IBOutlet weak var pokerButtonOutlet: UIButton!
    
    @IBOutlet weak var mensajeLabel: UILabel!
    
    @IBOutlet weak var jugador1Label: UILabel!
    
    @IBOutlet weak var jugador2Label: UILabel!
    
    @IBOutlet weak var jugador1TextField: UITextField!
    
    @IBOutlet weak var jugador2TextField: UITextField!
    
    @IBOutlet weak var j1carta1ImageView: UIImageView!
    
    @IBOutlet weak var j1carta2ImageView: UIImageView!
    
    @IBOutlet weak var j1carta3ImageView: UIImageView!
    
    @IBOutlet weak var j1carta4ImageView: UIImageView!
    
    @IBOutlet weak var j1carta5ImageView: UIImageView!
    
    @IBOutlet weak var j2carta1ImageView: UIImageView!
    
    @IBOutlet weak var j2carta2ImageView: UIImageView!
    
    @IBOutlet weak var j2carta3ImageView: UIImageView!
    
    @IBOutlet weak var j2carta4ImageView: UIImageView!
    
    @IBOutlet weak var j2carta5ImageView: UIImageView!
    
    @IBOutlet weak var formularioStackView: UIStackView!
    
    @IBOutlet weak var imagenesStackView: UIStackView!
    
    @IBOutlet weak var j1ImagenesStackView: UIStackView!
    
    @IBOutlet weak var j2ImagenesStackView: UIStackView!
    
    // Función que recorre las cartas y cargua sus imágenes del jugador 1
    func mostrarCartasJugador1(_ cartas: [Carta]) {
        j1ImagenesStackView.isHidden = false
        imagenesStackView.isHidden = false
        
        let imagenViews = [j1carta1ImageView, j1carta2ImageView, j1carta3ImageView, j1carta4ImageView, j1carta5ImageView]
        
        for i in 0..<cartas.count {
            let nombreImagen = cartas[i].valor + cartas[i].palo
            
            if let image = UIImage(named: nombreImagen) {
                imagenViews[i]?.image = image
            } else {
                print("Imagen no encontrada: \(nombreImagen)")
            }
        }
        
    }
    
    // Función que recorre las cartas y cargua sus imágenes del jugador 1
    func mostrarCartasJugador2(_ cartas: [Carta]) {
        j2ImagenesStackView.isHidden = false
        imagenesStackView.isHidden = false
        
        let imagenViews = [j2carta1ImageView, j2carta2ImageView, j2carta3ImageView, j2carta4ImageView, j2carta5ImageView]
        
        for i in 0..<cartas.count {
            let nombreImagen = cartas[i].valor + cartas[i].palo
            
            if let image = UIImage(named: nombreImagen) {
                imagenViews[i]?.image = image
            } else {
                print("Imagen no encontrada: \(nombreImagen)")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Estado inicial del boton
        pokerButtonOutlet.setTitle("Barajar", for: .normal)
        
        // Ocultar cartas al inicio
        imagenesStackView.isHidden = true
        j1ImagenesStackView.isHidden = true
        j2ImagenesStackView.isHidden = true

        // Mostrar formulario
        formularioStackView.isHidden = false

        // Mostrar label de bienvenida si corresponde
        mensajeLabel.isHidden = false
        
    }
}

// Funcion que contiene la alerta
func mostrarAlertaAnimada(en viewController: UIViewController, ganador: String, jugada: String) {
    // Crear la alerta
    let alerta = UIAlertController(title: "Ganó \(ganador)!!!!", message: jugada, preferredStyle: .alert)
    
    // Agregar boton OK
    alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    // Presentar la alerta sin animación
    viewController.present(alerta, animated: false) {
        // Aplicar animación personalizada al popup
        if let alertView = alerta.view.subviews.first?.subviews.first?.subviews.first {
            alertView.alpha = 0
            alertView.transform = CGAffineTransform(translationX: 0, y: 50)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                alertView.alpha = 1
                alertView.transform = .identity
            })
        }
    }
}


