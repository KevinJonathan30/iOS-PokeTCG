//
//  DetailViewModel.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

class DetailViewModel {
    weak var appCoordinator: AppCoordinator!
    private let dataService: AppDataServiceProtocol
    private let pokemonData: PokemonData?
    var recommendationCardList: [PokemonData] = []
    var errorMessage: String = ""
    var pageNumber = 1
    
    init(appCoordinator: AppCoordinator!, dataService: AppDataServiceProtocol, pokemonData: PokemonData?) {
        self.appCoordinator = appCoordinator
        self.dataService = dataService
        self.pokemonData = pokemonData
    }
    
    func getPokemonData() -> PokemonData? {
        return pokemonData
    }
    
    func getRecommendationCardList(completion: @escaping((Result<[PokemonData], Error>) -> Void)) {
        dataService.getCardRecommendation(page: pageNumber, types: pokemonData?.types, subtypes: pokemonData?.subtypes) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func goToDetail(index: Int) {
        guard index < recommendationCardList.count else { return }
        appCoordinator.goToDetailPage(pokemonData: recommendationCardList[index])
    }
}
