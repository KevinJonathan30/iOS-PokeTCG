//
//  PokeTCGTests.swift
//  PokeTCGTests
//
//  Created by Kevin Jonathan on 18/03/23.
//

import XCTest
@testable import PokeTCG

final class PokeTCGTests: XCTestCase {
    var homeSut: HomeViewModel!
    var detailSut: DetailViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let navigationController = UINavigationController.init()
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        let dataService = MockDataService.sharedInstance
        
        homeSut = HomeViewModel(appCoordinator: appCoordinator, dataService: dataService)
        detailSut = DetailViewModel(appCoordinator: appCoordinator, dataService: dataService, pokemonData: PokemonData(id: "", name: "", supertype: "", subtypes: [], level: "", hp: "", types: [], attacks: [], weaknesses: [], resistances: [], retreatCost: [], convertedRetreatCost: 0, set: nil, number: "", artist: "", rarity: "", flavorText: "", nationalPokedexNumbers: [], legalities: nil, images: nil, tcgplayer: nil, cardmarket: nil))
    }

    override func tearDownWithError() throws {
        homeSut = nil
        detailSut = nil
    }
    
    func test_getCardList() throws {
        let successExpect = expectation(description: "data1")
        
        var pokemonData: [PokemonData] = []
        var errorMessage: String = ""
        
        XCTAssertTrue(pokemonData.isEmpty)
        XCTAssertTrue(errorMessage.isEmpty)
        
        homeSut.getCardList { result in
            switch result {
            case .success(let data):
                pokemonData = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            if pokemonData.count == 1 && errorMessage.isEmpty {
                successExpect.fulfill()
            }
        }
        
        wait(for: [successExpect], timeout: 10)
    }
    
    func test_getSearchCardList() throws {
        let successExpect = expectation(description: "data1")
        let failExpect = expectation(description: "fail1")
        
        var pokemonData: [PokemonData] = []
        var errorMessage: String = ""
        
        XCTAssertTrue(pokemonData.isEmpty)
        XCTAssertTrue(errorMessage.isEmpty)
        
        homeSut.getSearchCardList(query: "Pikachu") { result in
            switch result {
            case .success(let data):
                pokemonData = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            if pokemonData.count == 2 && errorMessage.isEmpty {
                successExpect.fulfill()
            }
        }
        
        homeSut.getSearchCardList(query: "Harry Potter") { result in
            switch result {
            case .success(let data):
                pokemonData = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            if errorMessage == URLError.invalidResponse.localizedDescription {
                failExpect.fulfill()
            }
        }
        
        wait(for: [successExpect, failExpect], timeout: 10)
    }
    
    func test_getRecommendationCardList() throws {
        let successExpect = expectation(description: "data1")

        var pokemonData: [PokemonData] = []
        var errorMessage: String = ""
        
        XCTAssertTrue(pokemonData.isEmpty)
        XCTAssertTrue(errorMessage.isEmpty)

        detailSut.getRecommendationCardList { result in
            switch result {
            case .success(let data):
                pokemonData = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            if pokemonData.isEmpty && errorMessage.isEmpty {
                successExpect.fulfill()
            }
        }

        wait(for: [successExpect], timeout: 10)
    }

}

class MockDataService: NSObject {
    private override init() { }
    static let sharedInstance: MockDataService =  MockDataService()
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

extension MockDataService: AppDataServiceProtocol {
    func getCardList(page: Int = 1, completion: @escaping(Result<[PokemonData], Error>) -> Void) {
        completion(.success([PokemonData(id: "", name: "", supertype: "", subtypes: [], level: "", hp: "", types: [], attacks: [], weaknesses: [], resistances: [], retreatCost: [], convertedRetreatCost: 0, set: nil, number: "", artist: "", rarity: "", flavorText: "", nationalPokedexNumbers: [], legalities: nil, images: nil, tcgplayer: nil, cardmarket: nil)]))
    }
    
    func getSearchCardList(page: Int = 1, query: String, completion: @escaping(Result<[PokemonData], Error>) -> Void) {
        if query == "Pikachu" {
            completion(.success([PokemonData(id: "", name: "", supertype: "", subtypes: [], level: "", hp: "", types: [], attacks: [], weaknesses: [], resistances: [], retreatCost: [], convertedRetreatCost: 0, set: nil, number: "", artist: "", rarity: "", flavorText: "", nationalPokedexNumbers: [], legalities: nil, images: nil, tcgplayer: nil, cardmarket: nil), PokemonData(id: "", name: "", supertype: "", subtypes: [], level: "", hp: "", types: [], attacks: [], weaknesses: [], resistances: [], retreatCost: [], convertedRetreatCost: 0, set: nil, number: "", artist: "", rarity: "", flavorText: "", nationalPokedexNumbers: [], legalities: nil, images: nil, tcgplayer: nil, cardmarket: nil)]))
        } else {
            completion(.failure(URLError.invalidResponse))
        }
    }
    
    func getCardRecommendation(page: Int = 1, types: [String]?, subtypes: [String]?, completion: @escaping (Result<[PokemonData], Error>) -> Void) {
        if types != nil,
           subtypes != nil {
            completion(.success([]))
        } else {
            completion(.failure(URLError.invalidResponse))
        }
    }
}

