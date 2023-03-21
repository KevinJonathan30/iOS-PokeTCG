//
//  PokemonTcgPlayer.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

struct PokemonTcgPlayer: Codable {
    let url: String?
    let updatedAt: String?
    let prices: PokemonPrices?
}
