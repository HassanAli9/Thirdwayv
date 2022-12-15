import Foundation

enum NetworkError: LocalizedError {
    case serverError
    case noData
}

public class NetworkLayer {
    public static let shared = NetworkLayer()
    private init() {}
}

public extension NetworkLayer {
    func get<T: Decodable>(responseModel: T.Type, completionHandler: @escaping (Result<T, Error>) -> ()) {
        let url = URL(string: "https://my-json-server.typicode.com/HassanAli9/ProductsDB/db")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
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

extension NetworkLayer {
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
