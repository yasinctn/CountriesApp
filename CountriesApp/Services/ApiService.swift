//
//  ApiService.swift
//  CountriesApp
//
//  Created by Yasin Cetin on 10.05.2025.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    private let baseURL = URL(string: "https://turkiyeapi.herokuapp.com/api/v1/provinces")!

    private init() {}

    func fetchProvinces(completion: @escaping (Result<[Province], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: baseURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DataNil", code: -1, userInfo: nil)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ProvinceResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

