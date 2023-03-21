//
//  Endpoint.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

public struct API {
    static let baseUrl = "https://api.pokemontcg.io/v2"
}

public protocol Endpoint {
    var url: String { get }
}

public enum Endpoints {
    public enum Pokedex: Endpoint {
        case cards
        
        public var url: String {
            switch self {
            case .cards: return "\(API.baseUrl)/cards"
            }
        }
    }
}
