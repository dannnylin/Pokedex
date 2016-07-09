//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Danny on 7/9/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var evolutionTextLabel: UILabel!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvolutionImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        baseAttackLabel.text = pokemon.baseAttack
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        if pokemon.nextEvolutionId == "" {
            evolutionTextLabel.text = "No Evolutions"
            nextEvolutionImage.hidden = true
        } else {
            nextEvolutionImage.hidden = false
            nextEvolutionImage.image = UIImage(named: pokemon.nextEvolutionId)
            var labelText = "Next Evolution: \(pokemon.nextEvolutionText)"
            evolutionTextLabel.text = labelText
            
            if pokemon.nextEvolutionLevel != "" {
                labelText += " - LVL \(pokemon.nextEvolutionLevel)"
                evolutionTextLabel.text = labelText
            }
        }
        
    }
    
    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func create(pokemon: Pokemon) -> PokemonDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: PokemonDetailViewController.classForCoder()))
        guard let controller = storyboard.instantiateViewControllerWithIdentifier("PokemonDetailViewController") as? PokemonDetailViewController else {
            fatalError()
        }
        
        controller.pokemon = pokemon
        
        let _ = controller.view
        
        return controller
    }
}
