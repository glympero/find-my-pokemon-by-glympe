//
//  PokemonCell.swift
//  find-my-pokemon-by-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 11/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //Class to store the selected pokemon
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(pokemon: Pokemon){
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    func getName() -> String{
        return pokemon.name
    }
    
    func getId() -> Int{
        return pokemon.pokedexId
    }

}
