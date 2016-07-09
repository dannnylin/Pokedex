//
//  Pokemon.swift
//  Pokedex
//
//  Created by Danny on 7/9/16.
//  Copyright © 2016 Danny. All rights reserved.
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
    private var _baseAttack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
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
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(BASE_URL)\(POKEMON_URL)\(pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0 {
                    if let url = descriptionArray[0]["resource_uri"] {
                        let descUrl = NSURL(string: "\(BASE_URL)\(url)")!
                        Alamofire.request(.GET, descUrl).responseJSON { response in
                            let descriptionResult = response.result
                            if let descriptionDictionary = descriptionResult.value as? Dictionary<String, AnyObject> {
                                if let description = descriptionDictionary["description"] as? String {
                                    self._description = description
                                }
                            }
                            completed()
                        }
                        
                    } else {
                        self._description = ""
                    }
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let removedUrl = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let evolutionNum = removedUrl.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = evolutionNum
                                self._nextEvolutionText = to
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}