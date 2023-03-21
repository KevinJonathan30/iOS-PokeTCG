//
//  IndicatorCell.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 21/03/23.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    
    var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(indicator)
        indicator.startAnimating()
    }
}
