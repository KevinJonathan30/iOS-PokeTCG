//
//  DetailViewController.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var pokemonName: UILabel!
    @IBOutlet var pokemonStats: UILabel!
    @IBOutlet var pokemonType: UILabel!
    @IBOutlet var pokemonFlavor: UILabel!
    @IBOutlet var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPokemonData()
        setupCollectionView()
        getCardRecommendationList()
    }
    
    private func setupPokemonData() {
        setupNavigationBar()
        setupImage()
        setupPokemonName()
        setupPokemonStats()
        setupPokemonType()
        setupPokemonFlavor()
    }
    
    @objc func onImageTapped(_ sender: UITapGestureRecognizer) {
        let newImageView = UIImageView(image: cardImage.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        newImageView.alpha = 0
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
        UIView.animate(withDuration: 0.25) { () -> Void in
            newImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            newImageView.alpha = 1
        }
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25) { () -> Void in
            sender.view?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            sender.view?.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard self != nil else { return }
            sender.view?.removeFromSuperview()
        }
    }
    
    private func setupCollectionView() {
        cardCollectionView
            .register(UICollectionViewCell.self,
                      forCellWithReuseIdentifier: "cell")
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        
        cardCollectionView
            .setCollectionViewLayout(layout, animated: true)
    }
    
    private func getCardRecommendationList() {
        viewModel.getRecommendationCardList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if self.viewModel.pageNumber == 1 {
                    self.viewModel.recommendationCardList = data
                } else {
                    self.viewModel.recommendationCardList.append(contentsOf: data)
                }
                
                if self.viewModel.recommendationCardList.isEmpty {
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

// MARK: Setup Pokemon Data

extension DetailViewController {
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = viewModel.getPokemonData()?.name ?? "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupImage() {
        if let imgUrl = URL(string: viewModel.getPokemonData()?.images?.large ?? "") {
            cardImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            cardImage.sd_setImage(with: imgUrl) { (img, error, cache, url) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
            cardImage.isUserInteractionEnabled = true
            cardImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageTapped)))
        }
    }
    
    private func setupPokemonName() {
        pokemonName.text = viewModel.getPokemonData()?.name ?? ""
    }
    
    private func setupPokemonStats() {
        var pokemonStatsValue: String = ""
        
        if let types = viewModel.getPokemonData()?.types {
            for type in types {
                pokemonStatsValue += type + " "
            }
        }
        
        pokemonStatsValue += "(HP \(viewModel.getPokemonData()?.hp ?? "0"))"
        
        pokemonStats.text = pokemonStatsValue
    }
    
    private func setupPokemonType() {
        var pokemonTypeValue: String = ""
        
        pokemonTypeValue += viewModel.getPokemonData()?.supertype ?? ""
        pokemonTypeValue += " - "
        
        if let types = viewModel.getPokemonData()?.subtypes {
            for type in types {
                pokemonTypeValue += type + " "
            }
        }
        
        pokemonType.text = pokemonTypeValue
    }
    
    private func setupPokemonFlavor() {
        guard let flavorText = viewModel.getPokemonData()?.flavorText else {
            pokemonFlavor.text = "No Flavor Found"
            return
        }
        pokemonFlavor.text = "\"\(flavorText)\""
    }
}

// MARK: Other Cards

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.recommendationCardList.count == 0 && viewModel.errorMessage == "" {
            collectionView.setEmptyState()
        } else if viewModel.recommendationCardList.count == 0 && viewModel.errorMessage != "" {
            collectionView.setEmptyState(viewModel.errorMessage)
        } else {
            collectionView.setLoadedState()
        }
        return (viewModel.recommendationCardList.count > 0) ? (viewModel.recommendationCardList.count + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != viewModel.recommendationCardList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            if let imgUrl = URL(string: viewModel.recommendationCardList[indexPath.item].images?.small ?? "") {
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
            
            getCardRecommendationList()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToDetail(index: indexPath.item)
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != viewModel.recommendationCardList.count {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let heightPerItem = 300
            let widthPerItem = heightPerItem * 2 / 3
            return CGSize(width: widthPerItem - 16, height: heightPerItem)
        } else {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let heightPerItem = 300
            let widthPerItem = 32
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
        
    }
}


