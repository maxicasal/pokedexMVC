//
//  PokeListViewController.swift
//  MVPStart
//
//  Created by Maxi Casal on 8/11/16.
//  Copyright © 2016 Maxi Casal. All rights reserved.
//

import UIKit

class PokeListViewController: UIViewController {

  private let kPokeCellIdentifier = "kPokeCellIdentifier"
  private var pokemons = [Pokemon]()
  private let searchController = UISearchController(searchResultsController: nil)
  private var filteredPokemons = [Pokemon]()

  @IBOutlet var loadingView: UIView!
  @IBOutlet var pokemonTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
    loadPokemons()
  }
}

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching() ? filteredPokemons.count : pokemons.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let pokemon = isSearching() ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier(kPokeCellIdentifier, forIndexPath: indexPath) as! PokeTableViewCell
      cell.configure(pokemon)
      return cell
  }
}

extension PokeListViewController: UISearchResultsUpdating {

  func setupSearchController() {
    searchController.searchBar.frame = CGRectMake(0, 0, pokemonTableView.bounds.width, 30)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = true
    definesPresentationContext = true
    pokemonTableView.tableHeaderView = searchController.searchBar
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredPokemons = pokemons.filter({ pokemon in
      return pokemon.name!.lowercaseString.containsString(searchText.lowercaseString)
    })
    pokemonTableView.reloadData()
  }

  func isSearching() -> Bool {
    return searchController.active && searchController.searchBar.text != ""
  }

  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text! )
  }
}

extension PokeListViewController {

  private func loadPokemons() {
    APIManager.trustAllCertificates()
    for id in 1...5 {
      APIManager.sharedInstance.retrivePokemon(id, completionHandler: { (pokemon) in
        self.pokemons.append(pokemon)
        self.pokemonTableView.reloadData()
      })
    }
  }
}