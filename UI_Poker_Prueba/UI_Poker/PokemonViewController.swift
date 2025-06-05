//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  View Controller del juego Pokemon
//
//  Created by Bootcamp on 2025-06-02.
//

import UIKit
import PokemonAPI

class PokemonViewController: UIViewController {
    
    
    @IBOutlet weak var nombrePokemonLabel: UILabel!
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var buscarPokemonButton: UIButton!
    
    var nombreJugador: String?
    
    // Instanciar la API
    let pokemonAPI = PokemonAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asegura buen escalado de imagenes con respecto al Image View
        pokemonImageView.contentMode = .scaleAspectFit
        buscarPokemonAleatorio()
    }
    
    
    // Función para obtener un Pokémon aleatorio
    func buscarPokemonAleatorio() {
        let randomID = Int.random(in: 1...151) // Los 151 Pokémon originales
        Task {
            do {
                // Consulta un Pokémon por ID
                let pokemon = try await pokemonAPI.pokemonService.fetchPokemon(randomID)
                nombrePokemonLabel.text = pokemon.name?.capitalized

                // Buscar imagen por URL
                if let spriteURL = pokemon.sprites?.frontDefault,
                   let url = URL(string: spriteURL),
                   let data = try? Data(contentsOf: url) {
                    pokemonImageView.image = UIImage(data: data)
                } else {
                    pokemonImageView.image = nil
                }
            } catch {
                nombrePokemonLabel.text = "Error al obtener Pokémon"
                pokemonImageView.image = nil
            }
        }
    }

    // Acción del botón para buscar otro Pokémon
    @IBAction func buscarOtroPokemon(_ sender: UIButton) {
        buscarPokemonAleatorio()
    }
}

