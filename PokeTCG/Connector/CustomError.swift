//
//  CustomError.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

enum URLError: LocalizedError {
    case invalidResponse
    case addressUnreachable(URL)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server responded with garbage."
        case .addressUnreachable(let url): return "\(url) is unreachable."
        }
    }
}
