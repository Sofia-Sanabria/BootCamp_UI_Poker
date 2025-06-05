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
    
    @IBOutlet var vistaContenedor: UIView!
    
    @IBOutlet weak var bienvenidoLabel: UINavigationItem!
    
    @IBOutlet weak var jugadorLabel: UILabel!
    
    @IBOutlet weak var jugarButton: UIButton!
    
    @IBOutlet weak var puntajesOutlet: UIButton!
    
    @IBOutlet weak var ayudaOutlet: UIButton!
    
    @IBOutlet weak var ayudaTextView: UITextView!
    
    @IBOutlet weak var juegosScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var izquierdaButton: UIButton!
    
    @IBOutlet weak var derechaButton: UIButton!
    
    // Acumula el ancho total del scroll
    var contentWidth: CGFloat = 0.0
    
    // Extraer el ancho de la pantalla
    let anchoPagina = UIScreen.main.bounds.width

    // Nombres de imágenes que representan cada juego
    let juegosImagenes = ["poker_img", "tocame_img", "pokemon_img"]

    // Lista de juegos disponibles
    let juegos = ["Poker", "Tócame", "Pokemon"]
    
    // Diccionario de instrucciones que se veran en Ayuda
    let instrucciones: [String: String] = [
        "Poker": """
        Presiona el botón "Barajar" para repartir cinco cartas aleatorias. Tu objetivo es formar una mano ganadora según las reglas clásicas del póker, como pareja, doble pareja, trío, escalera, color, full, póker o escalera de color. 
        """,
        
        "Tócame": """
        El objetivo es tocar al osito que aparece en pantalla antes de que termine el tiempo. El osito aparecerá en distintos lugares de la pantalla de forma aleatoria. Cada vez que logres tocarlo a tiempo, sumarás un punto. 
        """,
        
        "Pokemon": """
        Explora el mundo Pokémon. Cada vez que presiones el botón, descubrirás un Pokémon diferente. Verás su nombre y su imagen. ¡Podrías encontrarte con Pikachu, Bulbasaur, Charmander y más!
        """
    ]
    
    // PickerView que se muestra al tocar el TextField
    var pickerView = UIPickerView()
    
    // Variable que almacena el nombre del jugador
    var jugadorText: String?
    
    @objc func handleHover(_ gesture: UIHoverGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            // Mostrar el botón con animación
            UIView.animate(withDuration: 0.3) {
                self.jugarButton.alpha = 1
                self.puntajesOutlet.alpha = 1
                self.ayudaOutlet.alpha = 1
            }
        case .ended:
            // Ocultar el botón con animación
            UIView.animate(withDuration: 0.3) {
                self.jugarButton.alpha = 0
                self.puntajesOutlet.alpha = 0
                self.ayudaOutlet.alpha = 0
            }
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Agregar detector de hover a una vista (por ejemplo, un contenedor)
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        vistaContenedor.addGestureRecognizer(hover)
    
        // Establecer el delegado para capturar eventos de desplazamiento
        juegosScrollView.delegate = self
        
        // Indicar la cantidad de páginas en el control
        pageControl.numberOfPages = juegosImagenes.count

        // Construcción de cada página del scroll (una por juego)
        for i in 0..<juegosImagenes.count {
            
            // Cargar imagen del juego desde Assets
            let image = UIImage(named: juegosImagenes[i])
            let imageView = UIImageView(image: image)
            
            // Ajustamos el contenido al espacio sin deformarlo
            imageView.contentMode = .scaleAspectFit
            
            // Definimos un tamaño
            let imageWidth = view.frame.width * 0.8  // 80% del ancho de la pantalla
            let imageHeight = juegosScrollView.frame.height * 0.8 // 80% de la altura del scroll
            imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)

            // Calculamos el centro horizontal y vertical
            let centerX = view.frame.midX + view.frame.width * CGFloat(i)
            let centerY = juegosScrollView.frame.height / 2
            imageView.center = CGPoint(x: centerX, y: centerY)

            // Agregamos la imagen al scroll
            juegosScrollView.addSubview(imageView)

            // Acumulamos el ancho del contenido total del scroll
            contentWidth += view.frame.width
        }
        
        // Asignamos el tamaño total del contenido desplazable del scroll
        juegosScrollView.contentSize = CGSize(width: contentWidth, height: juegosScrollView.frame.height)

        // Redondear bordes de los elementos visuales
        jugarButton.layer.cornerRadius = 20
        puntajesOutlet.layer.cornerRadius = 20
        ayudaOutlet.layer.cornerRadius = 20

        // Ocultar el TextView de ayuda al inicio
        ayudaTextView.isHidden = true

        // Mostrar el nombre del jugador en la etiqueta
        jugadorLabel.text = jugadorText

    }
    
    // Manejar la visibilidad de los botones de scroll
    func manejarScroll(direccion: Int? = nil) {
        
        // Define cuanto se mueve en cada paso
        let anchoPagina = view.frame.width
        
        // Posicion actual del scroll
        let paginaActual = Int(round(juegosScrollView.contentOffset.x / anchoPagina))
        let totalPaginas = juegos.count
        
        // Si se recibe una direccion, mover el scroll
        if let direccion = direccion {
            
            // No ir más allá de la primera o última página
            let nuevaPagina = max(0, min(paginaActual + direccion, totalPaginas - 1))
            let nuevoOffset = CGPoint(x: CGFloat(nuevaPagina) * anchoPagina, y: 0)
            
            // Mueve el scroll con animacion.
            juegosScrollView.setContentOffset(nuevoOffset, animated: true)
        }

        // Actualizar interfaz (botones y ayuda)
        let nuevaPosicion = Int(round(juegosScrollView.contentOffset.x / anchoPagina))
        derechaButton.isHidden = nuevaPosicion == 0
        izquierdaButton.isHidden = nuevaPosicion == totalPaginas - 1
        ayudaTextView.isHidden = true
    }

    // Boton para mover el scroll hacia la izquierda
    @IBAction func scrollDerecha(_ sender: UIButton) {
        manejarScroll(direccion: 1)
    }
    
    // Boton para mover el scroll hacia la izquierda
    @IBAction func scrollIzquierda(_ sender: UIButton) {
        manejarScroll(direccion: -1)
    }

    // Accion para navegar a la vista de puntajes
    @IBAction func puntajesButton(_ sender: UIButton) {
        guard let puntajesVC = storyboard?.instantiateViewController(withIdentifier: "puntajesID") as? TablaViewController else { return }
        puntajesVC.mostrarSoloJugador = true
        puntajesVC.cantidadTop = 5
        puntajesVC.nombreJugador = jugadorLabel.text ?? ""
        show(puntajesVC, sender: nil)
    }

    // Accion del boton Ayuda para mostrar instrucciones del juego seleccionado
    @IBAction func ayudaButton(_ sender: UIButton) {
        
        // Calcular la pagina visible dividiendo el desplazamiento del scroll
        let paginaActual = Int(round(juegosScrollView.contentOffset.x / view.frame.width))

        // Validar qe el indice sea valido dentro del array de juegos
        guard paginaActual >= 0 && paginaActual < juegos.count else {
            ayudaTextView.text = "No se pudo determinar el juego actual."
            ayudaTextView.isHidden = false
            return
        }
        
        // Obtener el nombre del juego visible actualmente
        let juegoSeleccionado = juegos[paginaActual]

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

        // Determinamos qué juego está seleccionado actualmente
        let juegoSeleccionado = juegos[pageControl.currentPage]

        // Obtenemos el storyboard principal
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        switch juegoSeleccionado {
        case "Poker":
            // Si está seleccionado Poker, navegamos a PokerViewController
            if let pokerVC = storyboard.instantiateViewController(withIdentifier: "pokerVC") as? PokerViewController {
                pokerVC.jugador1Text = jugadorLabel.text
                pokerVC.jugador2Text = "ChatGPT"
                show(pokerVC, sender: nil)
            }

        case "Tócame":
            // Si está seleccionado Tócame, navegamos a TocameViewController
            if let touchVC = storyboard.instantiateViewController(withIdentifier: "touchButtonVC") as? TocameViewController {
                touchVC.jugador1Text = jugadorLabel.text ?? ""
                show(touchVC, sender: nil)
            }

        case "Pokemon":
            // Si está seleccionado Pokemon, navegamos a PokemonViewController
            if let pokemonVC = storyboard.instantiateViewController(withIdentifier: "pokemonVC") as? PokemonViewController {
                pokemonVC.nombreJugador = jugadorLabel.text ?? ""
                show(pokemonVC, sender: nil)
            }

        default:
            // Si no coincide con ninguno, mostramos error
            let alert = UIAlertController(title: "Error", message: "Juego no implementado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// Extensión para manejar eventos de scroll horizontal
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Se actualiza el control de página mientras el usuario desliza
        let page = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = page
        
        // Manejo de visibilidad de botones de scroll y ayuda
        manejarScroll()
    }
}
