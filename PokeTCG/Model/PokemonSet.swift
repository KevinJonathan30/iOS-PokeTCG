//
//  PokemonSet.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

struct PokemonSet: Codable {
    let id: String?
    let name: String?
    let series: String?
    let printedTotal: Int?
    let total: Int?
    let legalities: PokemonLegalities?
    let ptcgoCode: String?
    let releaseDate: String?
    let updatedAt: String?
    let images: PokemonSetImages?
}
