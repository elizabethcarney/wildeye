//
//  FindListTableViewController.swift
//  wildeye
//
//  Created by Elizabeth Carney on 5/24/20.
//  Copyright © 2020 Elizabeth Carney. All rights reserved.
//

import Foundation
import UIKit

struct ItemLabel {
    var title : String
    var category : String
    var image : String
}

class FindListTableViewController: UITableViewController {
    
    var itemLabels = [
        ItemLabel(title: "a", category: "plant", image: "Flower"),
        ItemLabel(title: "b", category: "plant", image: "Flower"),
        ItemLabel(title: "c", category: "plant", image: "Flower"),
        ItemLabel(title: "d", category: "plant", image: "Flower"),
        ItemLabel(title: "e", category: "plant", image: "Flower"),
        ItemLabel(title: "f", category: "plant", image: "Flower"),
        ItemLabel(title: "g", category: "plant", image: "Flower"),
        ItemLabel(title: "h", category: "plant", image: "Flower"),
        ItemLabel(title: "i", category: "plant", image: "Flower"),
        ItemLabel(title: "j", category: "plant", image: "Flower")
    ]

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        let itemLabel = self.itemLabels[indexPath.row]
        cell.textLabel?.text = itemLabel.title
        cell.detailTextLabel?.text = itemLabel.category
        cell.imageView?.image = UIImage(named: itemLabel.image)

        return cell
    }

}
