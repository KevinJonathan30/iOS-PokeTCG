//
//  AppDataService.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation
import Alamofire

protocol AppDataServiceProtocol: AnyObject {
    func getCardList(page: Int, completion: @escaping(Result<[PokemonData], Error>) -> Void)
    func getSearchCardList(page: Int, query: String, completion: @escaping(Result<[PokemonData], Error>) -> Void)
    func getCardRecommendation(page: Int, types: [String]?, subtypes: [String]?, completion: @escaping(Result<[PokemonData], Error>) -> Void)
}

// MARK: Configuration

class AppDataService: NSObject {
    private override init() { }
    static let sharedInstance: AppDataService =  AppDataService()
    private var key: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "PokeTCG-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'PokeTCG-Info.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'PokeTCG-Info.plist'.")
            }
            return value
        }
    }
}

// MARK: API List

extension AppDataService: AppDataServiceProtocol {
    func getCardList(page: Int = 1, completion: @escaping(Result<[PokemonData], Error>) -> Void) {
        if let url = URL(string: Endpoints.Pokedex.cards.url + "?page=\(page)&pageSize=20") {
            AF.request(url)
                .validate()
                .responseDecodable(of: Pokemon.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value.data ?? []))
                    case .failure:
                        completion(.failure(URLError.invalidResponse))
                    }
                }
        } else {
            print("Fail to assemble URL")
        }
    }
    
    func getSearchCardList(page: Int = 1, query: String, completion: @escaping(Result<[PokemonData], Error>) -> Void) {
        if let url = URL(string: Endpoints.Pokedex.cards.url + "?q=name:\(query)*&page=\(page)&pageSize=20") {
            AF.request(url)
                .validate()
                .responseDecodable(of: Pokemon.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value.data ?? []))
                    case .failure:
                        completion(.failure(URLError.invalidResponse))
                    }
                }
        } else {
            print("Fail to assemble URL")
        }
    }
    
    func getCardRecommendation(page: Int = 1, types: [String]?, subtypes: [String]?, completion: @escaping (Result<[PokemonData], Error>) -> Void) {
        var query = ""
        
        if let subtypes = subtypes {
            var subtype = subtypes.first ?? ""
            subtype = subtype.components(separatedBy: " ").first ?? ""
            query += "subtypes:\(subtype)%20"
        }
        if let types = types {
            query += "-types:\(types.first ?? "")"
        }
        
        let queryString = !query.isEmpty ? "?q=\(query)&page=\(page)&pageSize=20" : "?page=\(page)&pageSize=20"
        
        if let url = URL(string: Endpoints.Pokedex.cards.url + queryString) {
            AF.request(url)
                .validate()
                .responseDecodable(of: Pokemon.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value.data ?? []))
                    case .failure:
                        completion(.failure(URLError.invalidResponse))
                    }
                }
        } else {
            print("Fail to assemble URL")
        }
    }
}
