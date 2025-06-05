//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  Clase para manejar el servicio de API en Alamofire
//
//  Created by Bootcamp on 2025-06-03.
//

import Foundation
import Alamofire // Importamos Alamofire para realizar peticiones HTTP

// Modelo de respuesta cuando el usuario hace login
struct AuthResponse: Codable {
    let access_token: String // Token de acceso (JWT)
    let user: User?          // Información del usuario (puede ser nula)
}

// Modelo que representa al usuario autenticado
struct User: Codable {
    let id: String           // ID único del usuario
    let email: String        // Email del usuario
    let user_metadata: UserMetadata?
}

// Incluir un campo personalizado nombre dentro de un user metadata
struct UserMetadata: Codable {
    let nombre: String?
}

// Modelo para enviar un puntaje al servidor
struct ScoreRequest: Codable {
    let user_id: String
    let game_id: Int
    let score: Int
    let date: String
}


// Maneja el retorno JSON
struct EmptyResponse: Codable {}

// Clase que maneja toda la comunicación con la API
class APIService {
    
    // Singleton: instancia única accesible desde cualquier parte de la app
    static let shared = APIService()
    private init() {} // Constructor privado para evitar otras instancias
    
    // Clave de API y URL base de Supabase
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
    
    private let baseURL = "https://lvmybcyhrbisfjouhbrx.supabase.co"
    
    // MARK: - LOGIN
    
    // Inicia sesión con email y contraseña
    func login(email: String, password: String, completion: @escaping (Result<(token: String, userID: String, nombre: String?), APIError>) -> Void) {
        // URL del endpoint de login con parámetro grant_type=password
        let endpoint = "\(baseURL)/auth/v1/token?grant_type=password"
        
        // Cuerpo de la solicitud: email y contraseña
        let parameters: APIParameters = ["email": email, "password": password]
        
        // Encabezados HTTP necesarios para Supabase
        let headers: APIHeaders = [
            "apikey": apiKey,
            "Content-Type": "application/json"
        ]
        
        // Ejecutamos la petición usando HTTPClient
        HTTPClient.request(
            endpoint: endpoint,
            method: .post,          // Método POST para login
            encoding: .json,        // Enviamos parámetros como JSON
            parameters: parameters,
            headers: headers,
            onSuccess: { (response: AuthResponse) in
                // Si recibimos un user_id, devolvemos el token y el ID
                if let user = response.user {
                    let token = response.access_token            // JWT
                    let userID = user.id                         // ID del usuario
                    let nombre = user.user_metadata?.nombre
                    SesionUsuario.shared.nombre = nombre// Nombre guardado en metadata
                    
                    completion(.success((token: token, userID: userID, nombre: nombre)))
                } else {
                    // Si no hay usuario, enviamos error personalizado
                    completion(.failure(APIError(msg: "Usuario no encontrado")))
                }
            },
            onFailure: { error in
                // Si ocurre un error, lo devolvemos al completador
                completion(.failure(error))
            }
        )
    }
    
    // MARK: - SIGNUP
    
    // Registra un nuevo usuario con email y contraseña
    func signup(nombre: String, email: String, password: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        let endpoint = "\(baseURL)/auth/v1/signup" // URL del endpoint de registro
        
        // Cuerpo de la solicitud: email y contraseña
        let parameters: APIParameters = [
            "email": email,
            "password": password,
            "data": [ // Aqui se guarda el nombre como metadata
                "nombre": nombre
                    ]
        ]
        
        // Encabezados necesarios
        let headers: APIHeaders = [
            "apikey": apiKey,
            "Content-Type": "application/json"
        ]
        
        // Ejecutamos la petición
        HTTPClient.request(
            endpoint: endpoint,
            method: .post,
            encoding: .json,
            parameters: parameters,
            headers: headers,
            onSuccess: { (_: EmptyResponse) in
                // Si la solicitud fue exitosa, devolvemos éxito sin datos
                completion(.success(()))
            },
            onFailure: { error in
                completion(.failure(error)) // Devolvemos el error recibido
            }
        )
    }
    
    // MARK: - REGISTRO DE PUNTAJES
    
    // Esta función obtiene una lista de puntajes desde la tabla "scores" en Supabase.
    func obtenerPuntajes(gameID: String, token: String, completion: @escaping (Result<[ScoreRequest], APIError>) -> Void) {
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        // Construir el endpoint con filtros
        let endpoint = "\(baseURL)/rest/v1/scores?user_id=eq.\(userID ?? "")"
        
        // Encabezados necesarios para autenticar
        let headers: APIHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(token)"
        ]
        
        // Realizar una solicitud GET a la API usando HTTPClient
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .url,
            headers: headers,
            onSuccess: { (puntajes: [ScoreRequest]) in
                completion(.success(puntajes))
            },
            onFailure: { error in
                completion(.failure(error))
            }
        )
    }
    
    // Envía un puntaje para un juego específico a la tabla "scores" en Supabase.
    func registrarPuntaje(userID: String, gameID: String, score: Int, token: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        let endpoint = "\(baseURL)/rest/v1/scores" // Endpoint para registrar puntaje
        
        // Obtenemos la fecha actual
        let fecha = Date().formatearFecha()
        
        
        // Parámetros que enviamos en el body de la solicitud
        let parameters: APIParameters = [
            "user_id": userID,
            "game_id": gameID,
            "score": score,
            "date": fecha,
            
        ]
        
        print("Enviando parámetros: \(parameters)")
        
        // Encabezados que incluyen el token del usuario
        let headers: APIHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(token)", // Token JWT en formato Bearer
            "Content-Type": "application/json"
        ]
        
        // Ejecutamos la solicitud
        HTTPClient.request(
            endpoint: endpoint,
            method: .post,
            encoding: .json,
            parameters: parameters,
            headers: headers,
            onSuccess: { (_: EmptyResponse) in
                completion(.success(()))
            },
            onFailure: { error in
                completion(.failure(error))
            }
        )

    }
}
 

