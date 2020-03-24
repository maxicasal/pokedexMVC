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
    private var lastPokemon = 1
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var pokemonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        loadInitialPokemons()
    }
}

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = isSearching() ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kPokeCellIdentifier, for: indexPath) as! PokeTableViewCell
        cell.configure(pokemon: pokemon)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching() ? filteredPokemons.count : pokemons.count
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let pokemon = isSearching() ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kPokeCellIdentifier, for: indexPath) as! PokeTableViewCell
        cell.configure(pokemon: pokemon)
        return cell
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSextionIndex = tableView.numberOfSections - 1
        let lastIndexRow = tableView.numberOfRows(inSection: lastSextionIndex) - 1
        if indexPath.row == lastIndexRow && indexPath.section == lastSextionIndex {
            self.getNextPokemons()
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let svc = segue.destination as! PokemonDetailViewController
        let indexPath = pokemonTableView.indexPathForSelectedRow
        svc.pokemon = isSearching() ? filteredPokemons[indexPath!.row] : pokemons[indexPath!.row]
    }
}

extension PokeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text! )
    }
    
    
    func setupSearchController() {
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: pokemonTableView.bounds.width, height: 30)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        pokemonTableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchController.dimsBackgroundDuringPresentation = true
        filteredPokemons = pokemons.filter({ pokemon in
            //.containsString(searchText.lowercassed()
            return (pokemon.name?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        pokemonTableView.reloadData()
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
}

extension PokeListViewController {
    
    private func loadInitialPokemons() {
        APIManager.trustAllCertificates()
        for id in 1...5 {
            self.lastPokemon = id
            APIManager.sharedInstance.retrivePokemon(pokeID: id, completionHandler: { (pokemon) in
                self.pokemons.append(pokemon)
                self.pokemonTableView.reloadData()
            })
        }
    }
    
    private func getNextPokemons() {
        if pokemons.count == lastPokemon {
            let pokemonRange = lastPokemon+1
            for id in pokemonRange...pokemonRange+5 {
                lastPokemon = id
                APIManager.sharedInstance.retrivePokemon(pokeID: id, completionHandler: { (pokemon) in
                    self.pokemons.append(pokemon)
                    self.pokemonTableView.reloadData()
                })
            }
        }
    }
}
