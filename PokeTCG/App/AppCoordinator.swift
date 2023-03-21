//
//  AppCoordinator.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.setupNavigationController()
    }
    
    func start() {
        goToHomePage()
    }
    
    func setupNavigationController() {
        self.navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController.navigationBar.barTintColor = .init(red: 22.0/255, green: 27.0/255, blue: 34.0/255, alpha: 1.0)
        self.navigationController.navigationBar.isTranslucent = true
    }
}

// MARK: Router

extension AppCoordinator {
    func goToHomePage() {
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let homeViewModel = HomeViewModel.init(appCoordinator: self, dataService: AppDataService.sharedInstance)
        homeViewController.viewModel = homeViewModel
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func goToDetailPage(pokemonData: PokemonData?) {
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let detailViewModel = DetailViewModel.init(
            appCoordinator: self,
            dataService: AppDataService.sharedInstance,
            pokemonData: pokemonData
        )
        detailViewController.viewModel = detailViewModel
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
