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
  @IBOutlet var firstTypeLabel: UILabel!
  @IBOutlet var secondTypeLabel: UILabel!
  @IBOutlet var numberLabel: UILabel!

  func configure(pokemon: Pokemon) {
    titleLabel.text = pokemon.name?.uppercaseString
    numberLabel.text = "\(pokemon.pokeNumber!)"
    let url = NSURL(string: "http://pokeapi.co/media/sprites/pokemon/\(pokemon.id!).png")
    if let data = NSData(contentsOfURL: url!) {
      avatarImageView.image = UIImage(data: data)
    }
  }
}
