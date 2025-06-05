//
//  Date+Formant.swift
//  UI_Poker
//
//  Created by Bootcamp on 2025-06-04.
//

import Foundation

extension Date {
    func formatearFecha() -> String {
        let formatter = DateFormatter()              // Crea un formateador de fecha
        formatter.dateFormat = "MM-dd-yyyy"          // Define el formato deseado
        return formatter.string(from: self)          // Devuelve la fecha como string
    }
}
