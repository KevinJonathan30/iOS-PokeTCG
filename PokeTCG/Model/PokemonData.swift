//
//  PokemonData.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

struct PokemonData: Codable {
    let id: String?
    let name: String?
    let supertype: String?
    let subtypes: [String]?
    let level: String?
    let hp: String?
    let types: [String]?
    let attacks: [PokemonAttack]?
    let weaknesses: [PokemonWeakness]?
    let resistances: [PokemonResistance]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let set: PokemonSet?
    let number: String?
    let artist: String?
    let rarity: String?
    let flavorText: String?
    let nationalPokedexNumbers: [Int]?
    let legalities: PokemonLegalities?
    let images: PokemonImages?
    let tcgplayer: PokemonTcgPlayer?
    let cardmarket: PokemonCardMarket?
}
