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
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _pokemonUrl: String!
    
    var name: String {
                return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    var descPokemon: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
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
        let url = NSURL(string: _pokemonUrl)!
        //Sending a request to url and getting the result when finished
        var descrUrl: String!
        //var nextEvoUrl: String!
        
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
                
                //Checking and grabing next evolution lvl and link to pokemon
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let level = evolutions[0]["level"] as? Int {
                        self._nextEvoLvl = "\(level)"
                    }
                    if let to = evolutions[0]["to"] as? String {
                        //Can't support mega pokemon atm
                        if to.rangeOfString("mega") == nil {
                            if let str = evolutions[0]["resource_uri"] as? String {
                                let newStr = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvoId = num
                                self._nextEvoTxt = to
//                                let endRange = str.endIndex.advancedBy(-1)..<str.endIndex
//                                str.removeRange(endRange)
//                                self._nextEvoTxt = str.substringFromIndex(str.startIndex.advancedBy(16))
                            }
                        }
                    }
//                    if let evoUrl = evolutions["resource_uri"] {
//                        nextEvoUrl = "\(URL_BASE)\(evoUrl)"
//                        //let evoUrl = NSURL(string: nextEvoUrl)!
//                        //            Alamofire.request(.GET, evoUrl).responseJSON { response in
//                        //                let result = response.result
//                        //                if let dict = result.value as? Dictionary<String, AnyObject>{
//                        //                    
//                        //                }
//                        //               completed()
//                        //            }
//
//                    }else{
//                        nextEvoUrl = ""
//                    }
                }
                
                //Checking and grabing the first available description
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] where descriptions.count > 0 {
                    if let descriptionUrl = descriptions[0]["resource_uri"]{
                        descrUrl  = "\(URL_BASE)\(descriptionUrl)"
                        let newUrl = NSURL(string: descrUrl)!
                        Alamofire.request(.GET, newUrl).responseJSON { response in
                            
                            let result = response.result
                            if let dict = result.value as? Dictionary<String, AnyObject> {
                                if let description = dict["description"] as? String{
                                    self._description = description
                                    //print(self._description)
                                }
                            }
                            completed()
                        }

                    }else{
                        self._description = "No Descr"
                    }
                }
            }
            
        }
    }
}
