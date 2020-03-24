//
//  PokeTableViewCell.swift
//  MVPStart
//
//  Created by Maxi Casal on 8/18/16.
//  Copyright © 2016 Maxi Casal. All rights reserved.
//

import UIKit

class PokeTableViewCell: UITableViewCell {

  @IBOutlet var avatarImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var experienceLabel: UILabel!

    func configure(pokemon: Pokemon) {
        titleLabel.text = pokemon.name?.uppercased()
        numberLabel.text = "\(pokemon.pokeNumber ?? 0)"
        experienceLabel.text = "\(pokemon.baseExperience ?? 0)"
        avatarImageView.image = UIImage(named: "squirtle.png")
        guard let url = URL(string: "http://pokeapi.co/media/sprites/pokemon/\(pokemon.id!).png") else { return }
        do {
            let data = try Data(contentsOf: url)
            avatarImageView.image = UIImage(data: data)
            pokemon.avatarImage = avatarImageView.image!
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
