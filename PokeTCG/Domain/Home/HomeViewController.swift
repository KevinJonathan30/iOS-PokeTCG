//
//  HomwViewController.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    
    @IBOutlet var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        getCardList()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(setupSearchBar))
    }
    
    @objc private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Pokédex"
        searchBar.showsCancelButton = true
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
    }
    
    private func setupCollectionView() {
        cardCollectionView
            .register(UICollectionViewCell.self,
                      forCellWithReuseIdentifier: "cell")
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        
        cardCollectionView
            .setCollectionViewLayout(layout, animated: true)
    }
    
    private func getCardList() {
        viewModel.getCardList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if self.viewModel.pageNumber == 1 {
                    self.viewModel.pokedexCardList = data
                } else {
                    self.viewModel.pokedexCardList.append(contentsOf: data)
                }
                
                if self.viewModel.pokedexCardList.isEmpty {
                    self.viewModel.errorMessage = "No Data"
                }
                self.viewModel.pageNumber += 1
            case .failure(let error):
                self.viewModel.errorMessage = error.localizedDescription
            }
            
            DispatchQueue.main.async {
                self.cardCollectionView.reloadData()
            }
        }
    }
    
    private func getSearchCardList(query: String) {
        viewModel.getSearchCardList(query: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if self.viewModel.pageNumber == 1 {
                    self.viewModel.pokedexCardList = data
                } else {
                    self.viewModel.pokedexCardList.append(contentsOf: data)
                }
                
                if self.viewModel.pokedexCardList.isEmpty {
                    self.viewModel.errorMessage = "No Data"
                }
                self.viewModel.pageNumber += 1
            case .failure(let error):
                self.viewModel.errorMessage = error.localizedDescription
            }
            
            DispatchQueue.main.async {
                self.cardCollectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.viewModel.pageNumber = 1
            getSearchCardList(query: searchBarText)
            viewModel.searchQuery = searchBarText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupNavigationBar()
        self.viewModel.pageNumber = 1
        getCardList()
        viewModel.searchQuery = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.viewModel.pageNumber = 1
            viewModel.searchQuery = searchText
            getCardList()
        }
    }
}

// MARK: Card List

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.pokedexCardList.count == 0 && viewModel.errorMessage == "" {
            collectionView.setEmptyState()
        } else if viewModel.pokedexCardList.count == 0 && viewModel.errorMessage != "" {
            collectionView.setEmptyState(viewModel.errorMessage)
        } else {
            collectionView.setLoadedState()
        }
        return (viewModel.pokedexCardList.count > 0) ? (viewModel.pokedexCardList.count + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != viewModel.pokedexCardList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            if let imgUrl = URL(string: viewModel.pokedexCardList[indexPath.item].images?.small ?? "") {
                cell.backgroundView = UIView()
                let imageView = UIImageView()
                imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
                imageView.sd_setImage(with: imgUrl) { (img, error, cache, url) in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                }
                imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
                cell.backgroundView?.addSubview(imageView)
                cell.backgroundView?.bringSubviewToFront(imageView)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicator", for: indexPath)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
            activityIndicator.startAnimating()
            activityIndicator.color = .white
            cell.addSubview(activityIndicator)
            
            if !viewModel.searchQuery.isEmpty {
                getSearchCardList(query: viewModel.searchQuery)
            } else {
                getCardList()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToDetail(index: indexPath.item)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != viewModel.pokedexCardList.count {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - layout.minimumInteritemSpacing
            let heightPerItem = widthPerItem * 3 / 2 - 16
            return CGSize(width: widthPerItem - 16, height: heightPerItem)
        } else {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width - layout.minimumInteritemSpacing
            return CGSize(width: widthPerItem - 16, height: 32)
        }
    }
}

