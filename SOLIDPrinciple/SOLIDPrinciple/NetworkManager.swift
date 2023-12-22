import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func fetchAsync<T: Decodable>(urlString: String, type: T.Type) async throws -> (Data, APIError?)
}

class NetworkManager: NetworkManagerProtocol {
    
    private let request: APIRequestProtocol
    private let response: APIResponseProtocol
    
    init(request: APIRequestProtocol = APIRequest(),
         response: APIResponseProtocol = APIResponse()) {
        self.request = request
        self.response = response
    }
    
    //async await
    func fetchAsync<T: Decodable>(urlString: String, type: T.Type) async throws -> (Data, APIError?) {
        
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
                httpUrlResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        return (data, nil)
        
    }
    
    func fetch<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                self.response.response(data: data, tyoe: type) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol APIRequestProtocol {
    func request(urlString: String, completion: @escaping (Result<Data?, APIError>) -> Void)
}


class APIRequest: APIRequestProtocol {
    func request(urlString: String, completion: @escaping (Result<Data?, APIError>) -> Void) {
        
        guard let url = URL(string: commentsURL) else {
            return completion(.failure(.badURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpUrlResponse = response as? HTTPURLResponse,
                  httpUrlResponse.statusCode == 200 else {
                return completion(.failure(.serverError))
            }
            
            completion(.success(data))
        }.resume()
        
    }
}

protocol APIResponseProtocol {
    func response<T: Decodable>(data: Data?, tyoe: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

class APIResponse: APIResponseProtocol {
    func response<T: Decodable>(data: Data?, tyoe: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let data = data,
              let decodeData = try? JSONDecoder().decode(tyoe.self, from: data) else {
            return completion(.failure(.decodeFailure))
        }
        completion(.success(decodeData))
    }
}


class MockNetworkManager: NetworkManagerProtocol {
    
    func fetchAsync<T>(urlString: String, type: T.Type) async throws -> (Data, APIError?) where T : Decodable {
        return (Data(), nil)
    }
    
    let apiRequest: APIRequestProtocol
    let apiResponse: APIResponseProtocol
    
    init(apiRequest: APIRequestProtocol = APIRequest(),
         apiResponse: APIResponseProtocol = APIResponse()) {
        self.apiRequest = apiRequest
        self.apiResponse = apiResponse
    }
    
    func fetch<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        
        guard let url = Bundle.main.url(forResource: urlString, withExtension: "json") else {
            return completion(.failure(.badURL))
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodeData = try JSONDecoder().decode(type, from: data)
            completion(.success(decodeData))
        } catch(let error) {
            print(error.localizedDescription)
            completion(.failure(.decodeFailure))
        }
        
        
        /*
        apiRequest.request(urlString: path) { result in
            switch result {
            case .success(let data):
                self.apiResponse.response(data: data, tyoe: type) { result in
                    switch result {
                    case .success(let decodeData):
                        completion(.success(decodeData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }*/
    }
    
    
}

