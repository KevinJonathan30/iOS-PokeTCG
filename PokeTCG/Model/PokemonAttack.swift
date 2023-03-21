//
//  PokemonAttack.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

struct PokemonAttack: Codable {
    let name: String?
    let cost: [String]?
    let convertedEnergyCost: Int?
    let damage: String?
    let text: String?
}
