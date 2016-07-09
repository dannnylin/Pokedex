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
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalizedString
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
