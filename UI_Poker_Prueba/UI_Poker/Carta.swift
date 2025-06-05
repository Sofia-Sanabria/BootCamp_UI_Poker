//
//  Ejercicio realizado por Sofia Sanabria
//  Carta
//
//  Created by Bootcamp on 2025-05-22.
//

class Carta {
    
    var valor: String
    var palo: String
    
    init(_ representa: String) {

        self.valor = String(representa.prefix(representa.count - 1))
        self.palo = String(representa.suffix(1))
    }
    
    func valorNumerico() -> Int {
        switch valor {
        case "A": return 14
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "T": return 10
        default:
            return Int(valor) ?? 0
        }
    }
}

struct Resultado {
    let jugador: String
    let tipoJugada: String
    let ranking: Int
    let valores: [Int]
}

func analizarMano(jugador: String, cartas: [Carta]) -> Resultado {

    var conteoValores: [Int: Int] = [:]
    var conteoPalos: [String: Int] = [:]
    var valores: [Int] = []
    
    for carta in cartas {
        let val = carta.valorNumerico()
        valores.append(val)
        conteoValores[val, default: 0] += 1
        conteoPalos[carta.palo, default: 0] += 1
    }
    
    valores.sort(by: >)
    let esColor = conteoPalos.values.contains(5)

    let esEscalera = (valores.max()! - valores.min()! == 4) && Set(valores).count == 5

    let escaleraBaja = Set(valores) == Set([14, 2, 3, 4, 5])
    
    var tipo = ""
    var ranking = 0
    
    if (esEscalera || escaleraBaja) && esColor {
        tipo = "Escalera de Color"; ranking = 9
    } else if conteoValores.values.contains(4) {
        tipo = "Poker"; ranking = 8
    } else if conteoValores.values.contains(3) && conteoValores.values.contains(2) {
        tipo = "Full"; ranking = 7
    } else if esColor {
        tipo = "Color"; ranking = 6
    } else if  esEscalera || escaleraBaja {
        tipo = "Escalera"; ranking = 5
    } else if conteoValores.values.contains(3) {
        tipo = "Trio"; ranking = 4
    } else if conteoValores.values.filter({$0 == 2}).count == 2 {
        tipo = "Doble par"; ranking = 3
    } else if conteoValores.values.contains(2) {
        tipo = "Par"; ranking = 2
    } else {
        tipo = "Carta alta"; ranking = 1
    }
    
    return Resultado (
        jugador: jugador,
        tipoJugada: tipo,
        ranking: ranking,
        valores: valores
    )
    
}


func determinarGanador(j1: Resultado, j2: Resultado) -> (String, String) {

    var ganadorEncontrado = ""
    var jugada = ""
    

    if j1.ranking > j2.ranking {
        ganadorEncontrado = j1.jugador
        jugada = j1.tipoJugada
    } else if j2.ranking > j1.ranking {
        ganadorEncontrado = j2.jugador
        jugada = j2.tipoJugada
    } else {
        // Mismo tipo de jugada, comparar valores
        let n = min(j1.valores.count, j2.valores.count)
        for i in 0..<n {
            if j1.valores[i] > j2.valores[i] {
                ganadorEncontrado = j1.jugador
                jugada = j1.tipoJugada
            } else if j2.valores[i] > j1.valores[i] {
                ganadorEncontrado = j2.jugador
                jugada = j2.tipoJugada
            }
        }
    }
    
    return (ganadorEncontrado, jugada)
}



