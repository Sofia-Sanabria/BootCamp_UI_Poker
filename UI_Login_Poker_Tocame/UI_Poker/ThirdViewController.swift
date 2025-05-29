//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  Tercer ViewController UI_Poker
//
//  Created by Bootcamp on 2025-05-26.
//

import UIKit
import Foundation

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var jugadorLabel: UILabel!
    
    @IBOutlet weak var puntajeLabel: UILabel!
    
    @IBOutlet weak var segundosLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var juegoView: UIView!
    
    @IBOutlet weak var ositoImageView: UIImageView!
    
    var puntaje = 0
    var tiempo = 5
    var countTiempo: Timer?
    var jugador1Text: String = " "

    // Funcion que Inicializa Contador de tiempo
    func startTimer() {
        countTiempo = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.tiempo > 0 {
                self.tiempo -= 1
                self.segundosLabel.text = "\(self.tiempo)"
            } else {
                self.finalizarJuego()
            }
        }
    }
    
    // Accion que Inicializa el juego
    @IBAction func startGame(_ sender: UIButton) {
        puntaje = 0
        tiempo = 5
        puntajeLabel.text = "Puntaje: 0"
        segundosLabel.text = "30"
        ositoImageView.isHidden = false
        startButton.isEnabled = false
        
        startTimer()
    }
    
    
    @IBAction func top5Button(_ sender: UIButton) {
        // Navegacion sin flecha
        guard let puntajesVC = storyboard?.instantiateViewController(withIdentifier: "puntajesID") as? NewViewController else { return  }
        show(puntajesVC, sender: nil)
    }
    
    
    @objc func ositoTocado() {
        // Aumentar puntaje
        puntaje += 1
        puntajeLabel.text = "Puntaje: \(puntaje)"
        
        // Obtener limites de movimiento
        let limiteX = juegoView.bounds.width - ositoImageView.frame.width
        let limiteY = juegoView.bounds.height - ositoImageView.frame.height
        
        // Generar posicion aleatoria dentro de esos limites
        let nuevoX = CGFloat.random(in: 0...limiteX)
        let nuevoY = CGFloat.random(in: 0...limiteY)

        // Mover con animacion
        UIView.animate(withDuration: 0.3) {
            self.ositoImageView.frame.origin = CGPoint(x: nuevoX, y: nuevoY)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        jugadorLabel.text = jugador1Text
        puntajeLabel.text = "Puntaje: 0"
        segundosLabel.text = "30"
        ositoImageView.isHidden = true
        
        // Hacer que la imagen de osito sea redondo
        ositoImageView.layer.cornerRadius = ositoImageView.frame.size.width / 2
        ositoImageView.clipsToBounds = true
        
        // Habilitar interaccion
        ositoImageView.isUserInteractionEnabled = true
        
        // Gesto para detectar los toques al osito
        let tapGestos = UITapGestureRecognizer(target: self, action: #selector(ositoTocado))
        ositoImageView.addGestureRecognizer(tapGestos)
    }

    // Funcion para finalizar el juego
    func finalizarJuego() {
        countTiempo?.invalidate()
        countTiempo = nil
        startButton.isEnabled = true
        ositoImageView.isHidden = true
        
        // Guardar puntaje actual en la lista global
        let nuevoPuntaje = JugadorPuntaje(nombre: jugador1Text, puntaje: puntaje)
        puntajes.append(nuevoPuntaje)

        
        // Mostrar alerta con puntaje
        let alert = UIAlertController(
            title: "¡Fin del juego!",
            message: "\(jugador1Text), tu puntaje fue: \(puntaje)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alert, animated: true)
    }
}

// Lista estatica para guardar todos los puntajes
var puntajes: [JugadorPuntaje] = []
