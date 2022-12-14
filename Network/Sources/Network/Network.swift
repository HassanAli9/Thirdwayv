import Foundation

enum NetworkError: LocalizedError {
    case serverError
    case noData
}

public class Network {
    public static let shared = Network()
    private init() {}
}

public extension Network {
    func get<T: Decodable>(responseModel: T.Type, completionHandler: @escaping (Result<T, Error>) -> ()) {
        let url = URL(string: "https://my-json-server.typicode.com/HassanAli9/ProductsDB/db")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completionHandler(.failure(NetworkError.serverError))
            } else {
                guard let data = data else {
                    completionHandler(.failure(NetworkError.noData))
                    return
                }

                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    completionHandler(.failure(NetworkError.noData))
                    return
                }

                completionHandler(.success(decodedData))
            }
        }.resume()
    }
}

extension Network {
    @available(iOS 15.0, *)
    func get<T: Decodable>(endPoint: URL, responseModel: T.Type) async throws -> T {
        let url = URL(string: "https://my-json-server.typicode.com/HassanAli9/productesDB/db")!

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.serverError
        }

        guard let decode = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.noData
        }
        return decode
    }
}
