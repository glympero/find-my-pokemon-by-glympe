//
//  Pokemon.swift
//  find-my-pokemon-by-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 11/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoTxt: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var pokemonUrl: String {
        return _pokemonUrl
    }
    
    var descPokemon: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
//        downloadPokemonDetails { () -> () in
//            
//        }
    }
    
    // "/api/v1/pokemon/1/1" with lazy loading (only download when needed"
    //Using Alamofire to download data from PokemonAPI
    
    
    
    func downloadPokemonDetails(completed: DownloadComplete){
        //Asynchronus download (data will not be instantly available to detail controller)
        //We need to tell to viewController when download is complete
        let url = NSURL(string: pokemonUrl)!
        //Sending a request to url and getting the result when finished
        var descrUrl: String!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            //Checking if result has any values
            //print(result.value.debugDescription)
            
            //Assigning result values to a dictionary - Using if - let to make sure that there is value
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                //Where used to check if types has any types at all
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
//                    var result = ""
//                    for type in types {
//                        result += " / "
//                        result += type["name"]!
//                    }
//                    self._type = result
//                    print(self._type)
                    
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                }else{
                    self._type = "No Types"
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] where descriptions.count > 0 {
                    if let descriptionUrl = descriptions[0]["resource_uri"]{
                        descrUrl  = "\(URL_BASE)\(descriptionUrl)"
                    }else{
                        descrUrl = ""
                    }
                }
            }
            let newUrl = NSURL(string: descrUrl)!
            Alamofire.request(.GET, newUrl).responseJSON { response in
                let result = response.result
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let description = dict["description"] as? String{
                        self._description = description
                    }
                }else{
                    self._description = "No Descr"
                }
                print(self._description)
                
            }
        }
    }
}
