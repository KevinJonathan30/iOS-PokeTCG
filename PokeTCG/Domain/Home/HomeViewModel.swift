//
//  HomeViewModel.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import Foundation

class HomeViewModel {
    weak var appCoordinator: AppCoordinator!
    private let dataService: AppDataServiceProtocol
    var pokedexCardList: [PokemonData] = []
    var errorMessage: String = ""
    var pageNumber: Int = 1
    var searchQuery: String = ""
    
    init(appCoordinator: AppCoordinator!, dataService: AppDataServiceProtocol) {
        self.appCoordinator = appCoordinator
        self.dataService = dataService
    }
    
    func goToDetail(index: Int) {
        guard index < pokedexCardList.count else { return }
        appCoordinator.goToDetailPage(pokemonData: pokedexCardList[index])
    }
    
    func getCardList(completion: @escaping((Result<[PokemonData], Error>) -> Void)) {
        dataService.getCardList(page: pageNumber) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func getSearchCardList(query: String, completion: @escaping((Result<[PokemonData], Error>) -> Void)) {
        guard !query.isEmpty else { return }
        dataService.getSearchCardList(page: pageNumber, query: query) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}
