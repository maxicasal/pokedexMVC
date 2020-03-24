//
//  APIManagerPokemonExtension.swift
//  MVPStart
//
//  Created by Maxi Casal on 8/25/16.
//  Copyright © 2016 Maxi Casal. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension APIManager {
    
    
    func retrivePockemon(pokeId: Int, complitionHandler: @escaping ((_ pokemon: Pokemon) -> Void)) {
        let url = APIManager.sharedInstance.kBasePokemonURL + "\(pokeId)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                let pokemon = self.parsePokemon(jsonResponse: json)
                if let pokemonMapped = pokemon {
                    complitionHandler(pokemonMapped)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func parsePokemon(jsonResponse : Any?) -> Pokemon? {
        let responseDictionary = jsonResponse as! Dictionary<String, Any>
        return Mapper<Pokemon>().map(JSONObject: responseDictionary)!
    }
}
