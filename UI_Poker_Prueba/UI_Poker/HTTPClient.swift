//
//  GitHub
//  Ejercicio realizado por Sofia Sanabria
//
//  Clase que realiza las peticiones HTTP usando Alamofire
//
//  Created by Bootcamp on 2025-06-03.
//

import Foundation
import Alamofire

// Maneja errores genéricos al fallar una solicitud.
struct APIError: Error {
    let msg: String
}
// Alias para headers y parámetros
typealias APIHeaders = HTTPHeaders
typealias APIParameters = [String: Any]

// Enum para traducir métodos personalizados a los de Alamofire.
enum APIMethod {
    case get
    case post
    case delete
    case put
    fileprivate var value: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .delete: return .delete
        case .put: return .put
        }
    }
}

// Enum que permite elegir entre parámetros JSON o URL.
enum APIEncoding {
    case json
    case url
    fileprivate var value: ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}

// Clase principal que realiza las peticiones HTTP
class HTTPClient {
    class func request<T: Codable>(
        endpoint: String,
        method: APIMethod = .get,
        encoding: APIEncoding = .url,
        parameters: APIParameters? = nil,
        headers: APIHeaders? = nil,
        onSuccess: @escaping (T) -> Void,
        onFailure: ((APIError) -> Void)? = nil
    )   {
        AF.request(
            endpoint,
            method: method.value,
            parameters: parameters,
            encoding: encoding.value,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            
            if let data = response.data {
               print("Respuesta recibida como JSON:")
               print(String(data: data, encoding: .utf8) ?? "No se puede mostrar")
            }
            
            switch response.result {
            case .success(let decodedObject):
                onSuccess(decodedObject)
            case .failure(let error):
                onFailure?(APIError(msg: "Error: \(error.localizedDescription)"))
            }
        }
    }
}
