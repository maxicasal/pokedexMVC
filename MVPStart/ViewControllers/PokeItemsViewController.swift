//
//  PokeItemsViewController.swift
//  MVPStart
//
//  Created by Maxi Casal on 8/11/16.
//  Copyright © 2016 Maxi Casal. All rights reserved.
//

import UIKit

class PokeItemsViewController: UIViewController {
    
    private let kItemCellIdentifier = "kItemCellIdentifier"
    private var items = [Item]()
    @IBOutlet var itemsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItemsFromPlist()
    }
    
    private func loadItemsFromPlist() {
        if  let path = Bundle.main.path(forResource: "PokeItems", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {
            guard let array = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [Item] else { return }
            self.items = array
            itemsTableView.reloadData()
        }
    }
}

extension PokeItemsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kItemCellIdentifier,for: indexPath) as! ItemTableViewCell
        cell.configure(item: item)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
}
